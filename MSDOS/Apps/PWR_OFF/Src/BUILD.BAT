:@echo off
C:\APPS\COMPIL~1\TASM50\BIN\TASM /m2 /w1 jmain.asm
C:\APPS\COMPIL~1\TASM50\BIN\TLINK /t /x jmain.OBJ
del *.obj
if exist joff.com del joff.com
ren jmain.com joff.com
pause