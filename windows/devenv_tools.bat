@echo off
if not exist "%~dp0busybox\busybox.exe" goto fail
set PATH=%~dp0bin;%~dp0neovim\bin;%~dp0mingit\cmd;%~dp0busybox;%~dp0clink;%~dp0cmake\bin;%~dp0clangd\bin;%~dp0bazel;%~dp0python;%~dp0cpptools\bin;%PATH%
set CLINK_PATH=%~dp0clink\scripts
doskey j=zoxide query $*
doskey ff=fzf $*

if not exist "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat" goto clink
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"

:clink
%~dp0clink\clink_x64.exe inject
goto :eof

:fail
color 4f
echo ERROR: ¯\_(ツ)_/¯
title ERROR
goto :eof
