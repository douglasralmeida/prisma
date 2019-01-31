#ifndef _CONFIG_H_
#define _CONFIG_H_

#include <stdio.h>
#include <wchar.h>
#include <windows.h>
#include "inireader.h"

#define MAQUINANOME_TAMANHO 64

typedef struct maquina_s {
  wchar_t nome[MAQUINANOME_TAMANHO];
  wchar_t nomearquivo[MAQUINANOME_TAMANHO];
} maquina_t;

typedef struct config_s {
  inifile_t* file;
  int count;
  maquina_t* maquinas;
} config_t;

config_t* config_criar();

int config_abrir(config_t* config, const wchar_t* arquivo);

int config_parse(config_t* config);

int config_escolher(config_t* config, HINSTANCE hInstance);

void config_executar(config_t* config, int id);

#endif