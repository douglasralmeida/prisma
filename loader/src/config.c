#include <config.h>
#include <dialogos.h>

config_t* config_criar(){
  config_t* pconfig;

  pconfig = malloc(sizeof(config_t));
  if (pconfig)
    return pconfig
  else
    return NULL;
}

int config_abrir(config_t* config, char* arquivo) {
  FILE* file;

  file = fopen(arquivo, "rt");
  config->file = file;

  return (file != NULL);
}

int config_parse(config_t* config) {
  char buffer[128];

  fseek(config_t->file, sizeof(char) * 10, SEEK_SET);
  if (fgetc(config_t->file) != '\n') {
    msgerro("Bad file. Not newline in 10th position.");
    return 0;
  }
  while (fgetc(config_t->file) != EOF) {
    fscanf(config_t->file, "%s", buffer);
    msgerro(buffer);
  }
}