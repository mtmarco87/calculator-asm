@echo off

rem echo %0		==> full quoted path+filename ("path\to\file")
rem echo %~dp0		==> full path (path\to\)
rem echo %~f0		==> full path+filename (path\to\file)
rem echo %~nx0		==> filename (file)		
rem call "C:\\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" amd64
rem link /entry:start /subsystem:console %1 kernel32.lib

echo Linking Win64 app...
powershell "& '%~dp0vsexec.bat' link %*"

