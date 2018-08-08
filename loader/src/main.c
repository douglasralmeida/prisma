#include <windows.h>
#include <commctrl.h>

const TASKDIALOG_BUTTON botoes[] = {
    {101, L"Prisma ADJ"},
    {102, L"Prisma Barreiro"},
};

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
  TASKDIALOGCONFIG dialogo = {0};
  
  dialogo.cbSize = sizeof(dialogo);
  dialogo.hInstance = hInstance;
  dialogo.dwFlags = TDF_USE_COMMAND_LINKS;
  dialogo.pszWindowTitle = L"Máquinas Prisma";
  dialogo.pszMainIcon = TD_INFORMATION_ICON;
  dialogo.pszMainInstruction = L"Escolha uma máquina Prisma abaixo para abrí-la.";
  dialogo.cButtons = ARRAYSIZE(botoes);
  dialogo.pButtons = botoes;
  dialogo.pszContent = L"TEXTO.";
  TaskDialogIndirect(&dialogo, NULL, NULL, NULL);
  
  return 0; 
}