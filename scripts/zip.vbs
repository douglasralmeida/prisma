Set objArgs = WScript.Arguments
InputFolder = objArgs(0)
ZipFile = objArgs(1)

Set fso = CreateObject("Scripting.FileSystemObject")
Set objZipFile = fso.CreateTextFile(ZipFile, True)
objZipFile.Write "PK" & Chr(5) & Chr(6) & String(18, vbNullChar)
objZipFile.Close

Set objShell = CreateObject("Shell.Application")
Set source = objShell.NameSpace(InputFolder).Items
Set objZip = objShell.NameSpace(fso.GetAbsolutePathName(ZipFile))
if not objZip is nothing then
  objZip.CopyHere(source)
  Do Until source.Count <= objZip.Items.Count
    WScript.Sleep(200)
  Loop 
end if