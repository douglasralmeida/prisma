'Script para manipulação do texto da área de transferência
'do Windows

Function RemoverAcentos(texto As String) As String
  Const caracAcentuados = "ÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÖÔÚÙÛÜÇÑ"
  Const caracSimplifica = "AAAAAEEEEIIIIOOOOOUUUUCN"
  Dim textoSaida As String
  
  textoSaida = texto
  For i = 1 To Len(caracAcentuados)
    A = Mid(caracAcentuados, i, 1)
    B = Mid(caracSimplifica, i, 1)
    textoSaida = Replace(textoSaida, A, B)
  Next

  RemoverAcentos = textoSaida
End Function

Function RemoverCaracteresInvalidos(texto As String) As String
  Dim textoSaida As String
  
  For i = 1 To Len(texto)
    c = Mid(texto, i, 1) 'Seleciona o caractere na posição i
    If (c >= "0" And c <= "9") Or (c >= "A" And c <= "Z") Or (c = " ") Then
      textoSaida = textoSaida & c 'adiciona o caractere na saída
    End If
  Next
  
  RemoverCaracteresInvalidos = textoSaida
End Function

Sub Main()
  Dim textoColar As String

  if Len(Clipboard) > 0 Then
    textoColar = UCase(Clipboard)
    textoColar = RemoverAcentos(textoColar)
    textoColar = RemoverCaracteresInvalidos(textoColar)
    textoColar = textoColar & vbCr
    ActiveSession.Output(textoColar)
  End If
End Sub
