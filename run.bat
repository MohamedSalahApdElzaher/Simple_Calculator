set name=simpleCalculator
\masm32\bin\ml /c /Zd /coff %name%.asm
\masm32\bin\link /SUBSYSTEM:CONSOLE %name%.obj
%name%.exe