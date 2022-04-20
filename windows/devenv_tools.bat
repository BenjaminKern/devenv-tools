@echo off
if not exist "%~dp0bin\busybox.exe" goto fail
set PATH=%~dp0bin;%~dp0neovim\bin;%~dp0mingit\cmd;%PATH%
:: doskey j=zoxide query $*
:: doskey ff=fzf $*

if not exist "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat" goto fail
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
goto :eof

:fail
color 4f
echo ERROR: ¯\_(ツ)_/¯
title ERROR
goto :eof
