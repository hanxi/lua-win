echo off
set local_dir=%cd%
set cur_dir=%~dp0

if not exist "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" (
    echo "Not found vswhere.exe"
    exit
)
cd /d "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer"
for /f "usebackq tokens=*" %%i in (`vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
  set InstallDir=%%i
)
if not exist "%InstallDir%\VC\Auxiliary\Build\vcvarsall.bat" (
    echo "Not found vcvarsall"
    exit
)
cd /d "%InstallDir%\VC\Auxiliary\Build"

set VSCMD_DEBUG=0

where cl.exe
if %ERRORLEVEL% == 1 call vcvarsall.bat x86

cd /d %cur_dir%


set LUA_VERSION=%1
if "%LUA_VERSION%"=="" (
set LUA_VERSION=5.3.5
)

set LUA_SRC_DIR=%cur_dir%\srcs\lua-%LUA_VERSION%\src
if not exist "%LUA_SRC_DIR%" (
    cd /d %cur_dir%\srcs
    tar -zxf lua-%LUA_VERSION%.tar.gz
)
set LUA_INSTALL_PATH=%cur_dir%\lua-%LUA_VERSION%

cd /d %cur_dir%
call nmake /nologo /f lua-%LUA_VERSION%.makefile clean
nmake /nologo /f lua-%LUA_VERSION%.makefile
call nmake /nologo /f lua-%LUA_VERSION%.makefile clean
