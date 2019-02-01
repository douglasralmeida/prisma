#ifndef _APP_H_
#define _APP_H_

#include <wchar.h>
#include <windows.h>

HINSTANCE aplicacao_handle();

void aplicacao_init(HINSTANCE handle);

wchar_t* aplicacao_nome();

#endif