#ifndef _CONFIG_H_
#define _CONFIG_H_

typedef struct maquina_s {
  char nome[64];
  char nomearquivo[64];
} maquina_t;

typedef struct config_s {
  FILE* file;
  int count;
  maquina_t* maquinas;
} config_t;

config_t* config_criar();

int config_abrir(config_t* config, char* arquivo);

int config_parse(config_t* config);

#endif
