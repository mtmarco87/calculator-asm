@echo off

REM ----------------------------------------
REM Script to set up the Visual Studio environment
REM Uses vswhere.exe to autodiscover vcvarsall.bat
REM ----------------------------------------

REM Define paths
set "VSWHERE_PATH=C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"
set "VCVARSALL_PATH="

REM Step 1: Check if vswhere.exe exists
if not exist "%VSWHERE_PATH%" (
    echo Error: vswhere.exe not found. Please install Visual Studio Installer.
    exit /b 1
)

REM Step 2: Attempt to autodiscover vcvarsall.bat
for /f "delims=" %%i in ('"%VSWHERE_PATH%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -find **/vcvarsall.bat 2^>nul') do set "VCVARSALL_PATH=%%i"

REM Step 3: Check if vcvarsall.bat was found
if "%VCVARSALL_PATH%"=="" (
    echo Error: Could not autodiscover vcvarsall.bat. Ensure Visual Studio is installed.
    exit /b 1
)

REM Step 3: Display the discovered vcvarsall.bat path
echo Discovered vcvarsall: "%VCVARSALL_PATH%"
echo.

REM Step 4: Call vcvarsall.bat and execute the passed command
call "%VCVARSALL_PATH%" amd64 && %*

REM Step 5: Check if the command executed successfully
if errorlevel 1 (
    echo Error: Visual Studio command execution failed.
    exit /b 1
)