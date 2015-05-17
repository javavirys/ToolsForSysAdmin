:@echo off
C:\APPS\COMPIL~1\TASM50\BIN\TASM /m2 /w1 jcpuid.ASM
C:\APPS\COMPIL~1\TASM50\BIN\TLINK /t /x jcpuid.OBJ
del *.obj
pause