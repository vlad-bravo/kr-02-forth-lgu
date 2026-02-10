@echo off
del forth.bin>nul
del forth.o>nul
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -v2 -o forth.o forth.asm
C:\dev\wla_dx_v10.6_Win64\wlalink.exe -r -v link.cfg forth.bin
fc /b forth.bin ..\bin\forthlgu.rk
