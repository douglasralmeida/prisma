#include "app.h"
#include "dialogos.h"
#include "config.h"

#define UNUSED(x) (void)(x)

void aplicacao_executar() {
  int maquinaid;
  config_t* config;

  config = config_criar();
  if (!config) {
    msgerro(L"Erro interno do programa. Você pode não ter memória suficiente.");
    return;
  }
  if (!config_abrir(config, L"maquinas.ini")) {
    msgerro(L"Erro ao abrir as configurações do programa. Será necessário reinstalar este aplicativo.");
    return;
  }
  if (!config_parse(config)){
    msgerro(L"Erro ao processar as configurações do programa. Será necessário reinstalar este aplicativo.");
    return;
  }
  maquinaid = config_escolher(config, aplicacao_handle());
  if (maquinaid > 100) 
    config_executar(config, maquinaid);
}

int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPWSTR lpCmdLine, int nCmdShow) {
  UNUSED(hPrevInstance);
  UNUSED(lpCmdLine);
  UNUSED(nCmdShow);

  aplicacao_init(hInstance);
  aplicacao_executar();

  return 0; 
}