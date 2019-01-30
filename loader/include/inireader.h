#ifndef _INIREADER_H_
#define _INIREADER_H_

#include <stdio.h>
#include <wchar.h>

#define BUFFER_LENGTH 128

typedef struct inifile_s {
  wchar_t buffer[BUFFER_LENGTH];
  FILE* file;
  int eof;
} inifile_t;


inifile_t* iniparser_create();

void iniparser_destroy(inifile_t** pinifile);

int iniparser_open(inifile_t* inifile, const wchar_t* file);

wchar_t* iniparser_readstring(inifile_t* inifile, const wchar_t* key);

int iniparser_section(inifile_t* inifile, const wchar_t* section);

#endif