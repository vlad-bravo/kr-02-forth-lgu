@echo off

del forth.bin 2>nul
del *.o 2>nul

C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o forth.o forth.asm

C:\dev\wla_dx_v10.6_Win64\wlalink.exe link.cfg forth.bin

del *.o 2>nul

fc /b forth.bin ..\bin\forthlgu.rk
