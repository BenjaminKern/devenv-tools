@echo off
set PATH=%~dp0bin;%~dp0nvim-win64\bin;%~dp0mingit\cmd;%~dp0clink;%PATH%
set CLINK_PATH=%~dp0clink\scripts
doskey j=zoxide query $*
doskey ff=fzf $*

for /f "usebackq delims=" %%i in (`"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -prerelease -latest -property installationPath`) do (
  if exist "%%i\Common7\Tools\vsdevcmd.bat" (
    call "%%i\Common7\Tools\vsdevcmd.bat" %*
    goto clink
  )
)

color 4f
echo ERROR: ¯\_(ツ)_/¯
title ERROR
goto :eof

:clink
%~dp0clink\clink_x64.exe inject
goto :eof
