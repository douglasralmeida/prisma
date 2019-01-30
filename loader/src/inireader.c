#include <ctype.h>
#include <stdlib.h>
#include "inireader.h"

const wchar_t* triml(const wchar_t* string) {
    const wchar_t* p;

    p = string;
    while (iswspace(p[0]))
        p++;

    return p;
}

int is_firstchar(const wchar_t* string, const wchar_t symbol) {
    const wchar_t* p;
    int foundchar;

    foundchar = (string[0] == symbol);
    if (!foundchar) {
        p = triml(string);
        foundchar = (p[0] == symbol);
    }

    return foundchar;    
}

int lineis_blank(const wchar_t* string) {
    return is_firstchar(string, L'\n');
}

int lineis_comment(const wchar_t* string) {
    return is_firstchar(string, L';');
}

int lineis_section(const wchar_t* string) {
    return is_firstchar(string, L'[');
}

int lineis_useless(const wchar_t* string) {
    return lineis_blank(string) || lineis_comment(string);
}

inifile_t* iniparser_create() {
    inifile_t* inifile;

    inifile = (inifile_t*)malloc(sizeof(inifile_t));
    if (inifile) {
        inifile->file = NULL;
        inifile->eof = 0;

        return inifile;
    } else
        return NULL;
}

void iniparser_destroy(inifile_t** pinifile) {
    inifile_t* inifile;

    inifile = *pinifile;
    if (inifile) {
        if (inifile->file)
            fclose(inifile->file);
        free(inifile);
        inifile = NULL;
    }
}

int iniparser_nextline(inifile_t* inifile) {
    do {
        if (!fgetws(inifile->buffer, BUFFER_LENGTH, inifile->file))
            return 0;
    }
    while (lineis_useless(inifile->buffer));
    return 1;
}

int iniparser_open(inifile_t* inifile, const wchar_t* file) {
    inifile->file = _wfopen(file, L"r");
    inifile->eof = 0;
    
    return (file != NULL);
}

wchar_t* iniparser_readstring(inifile_t* inifile, const wchar_t* key) {
    wchar_t* inikey;
    wchar_t* value;
    int pos;

    if (iniparser_nextline(inifile)) {
        value = wcschr(inifile->buffer, L'=');
        if (!value)
            return NULL;
        value++;
        inikey = wcstok(inifile->buffer, L"=");
        if (!inikey)
            return NULL;
        if (wcscmp(key, inikey) != 0)
            return NULL;
        pos = wcscspn(value, L";\n\r");
        if ((int)wcslen(value) != pos)
            value[pos] = L'\0';
        return value;
    } else {
        inifile->eof = 1;
    }

    return NULL;
}

int iniparser_section(inifile_t* inifile, const wchar_t* section) {
    wchar_t* lineend;

    if (iniparser_nextline(inifile)) {
        if (lineis_section(inifile->buffer)) {
            lineend = wcschr(inifile->buffer, L']');
            if (lineend) {
                *lineend = L'\0';
                return (wcscmp(inifile->buffer+1, section) == 0);
            }
        }
    } else {
        inifile->eof = 1;
    }
    return 0;
}