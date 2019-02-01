#include <windows.h>
#include "dialogos.h"

void msgerro(wchar_t* mensagem) {
    MessageBoxW(NULL, mensagem, L"Carregador do Prisma", 0);
}