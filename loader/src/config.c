#include <shlwapi.h>
#include <windows.h>
#include <commctrl.h>
#include "config.h"
#include "dialogos.h"

void config_maquinascriar(config_t* config, int capacidade) {
    config->maquinas = (maquina_t*)malloc(sizeof(maquina_t) * capacidade);
    if (config->maquinas) {
        config->count = capacidade;
    }
}

void config_maquinasadicionar(config_t* config, maquina_t* maquina, int pos) {
    wcsncpy(config->maquinas[pos].nome, maquina->nome, MAQUINANOME_TAMANHO);
    wcsncpy(config->maquinas[pos].nomearquivo, maquina->nomearquivo, MAQUINANOME_TAMANHO);
}

config_t* config_criar(){
    config_t* config;

    config = (config_t*)malloc(sizeof(config_t));
    if (config) {
        config->file = iniparser_create();
        if (config->file) {
            config->count = 0;
            config->maquinas = NULL;
            return config;
        }
        else {
            free(config);
            return NULL;
        }
    } else
        return NULL;
}

void config_destruir(config_t** pconfig) {
    config_t* config;

    config = *pconfig;
    if (config) {
        if (config->file)
            iniparser_destroy(&config->file);
        free(config);
        config = NULL;
    }
}

int config_abrir(config_t* config, const wchar_t* arquivo) {
    return iniparser_open(config->file, arquivo);
}

int config_parse(config_t* config) {
    int i = 0;
    wchar_t* value;
    maquina_t maquina;

    /* cabeçalho [INFO] */
    if (iniparser_section(config->file, L"info")){
        value = iniparser_readstring(config->file, L"quantidade");
        config_maquinascriar(config, _wtoi(value));
    } else
        return 0;

    /* cabeçalho [MAQUINA] */
    while (i < config->count) {
        if (iniparser_section(config->file, L"maquina")) {
            value = iniparser_readstring(config->file, L"nome");
            wcsncpy(maquina.nome, value, MAQUINANOME_TAMANHO);
            value = iniparser_readstring(config->file, L"arquivo");
            wcsncpy(maquina.nomearquivo, value, MAQUINANOME_TAMANHO);
            config_maquinasadicionar(config, &maquina, i);
        }
        i++;
    }

    return (i > 0 && i == config->count);
}

TASKDIALOG_BUTTON* botoes_criar(maquina_t* maquinas, int quantidade) {
    int i;
    TASKDIALOG_BUTTON* botoes;

    botoes = (TASKDIALOG_BUTTON*)malloc(sizeof(TASKDIALOG_BUTTON) * quantidade);
    if (botoes) {
        for (i = 0; i < quantidade; i++) {
            botoes[i].nButtonID = 100 + i;
            botoes[i].pszButtonText = maquinas[i].nome;
        }
    }

    return botoes;
}

int config_escolher(config_t* config, HINSTANCE hInstance) {
    int botaoPressionado = 0;
    const TASKDIALOG_BUTTON* botoes;
    TASKDIALOGCONFIG dialogo = {0};

    botoes = botoes_criar(config->maquinas, config->count);
    dialogo.cbSize = sizeof(dialogo);
    dialogo.hInstance = hInstance;
    dialogo.dwFlags = TDF_USE_COMMAND_LINKS;
    dialogo.pszWindowTitle = L"Máquinas Prisma";
    dialogo.pszMainIcon = TD_INFORMATION_ICON;
    dialogo.pszMainInstruction = L"Escolha uma máquina Prisma abaixo para abrí-la.";
    dialogo.cButtons = config->count;
    dialogo.pButtons = botoes;
    dialogo.pszContent = L"TEXTO.";
    TaskDialogIndirect(&dialogo, &botaoPressionado, NULL, NULL);

    return botaoPressionado;
}

void config_executar(config_t* config, int id) {
    SHELLEXECUTEINFOW shexeInfo;

    shexeInfo.cbSize = sizeof(SHELLEXECUTEINFO);
    shexeInfo.fMask = SEE_MASK_DEFAULT;
    shexeInfo.hwnd = NULL;
    shexeInfo.lpVerb = L"open";
    shexeInfo.lpFile = config->maquinas[id-100].nomearquivo;
    shexeInfo.lpParameters = NULL;
    shexeInfo.lpDirectory = NULL;
    shexeInfo.nShow = SW_SHOWNORMAL;
    shexeInfo.hInstApp = NULL;
    ShellExecuteExW(&shexeInfo);
}