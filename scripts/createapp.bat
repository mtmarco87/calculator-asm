@echo off

if not exist out mkdir out
call "%~dp0compileasm.bat" "%~dpn1.asm" -o out\%~n1.obj -g
call "%~dp0linkasm.bat" /OUT:out\%~n1.exe %2 out\%~n1.obj
