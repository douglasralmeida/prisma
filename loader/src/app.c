#include "app.h"

struct app_s {
  wchar_t nome[64];
  HINSTANCE handle;
} aplicacao;

HINSTANCE aplicacao_handle() {
  return aplicacao.handle;
}

void aplicacao_init(HINSTANCE handle) {
  aplicacao.handle = handle;
  wcsncpy(aplicacao.nome, L"Carregador do Prisma", 20);
}

wchar_t* aplicacao_nome() {
  return aplicacao.nome;
}