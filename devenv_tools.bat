@echo off

set "BASE=%~dp0"

rem Check for vswhere.exe
if not exist "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" (
    color 4f
    echo ERROR: vswhere.exe not found at expected location
    title ERROR
    goto :eof
)

rem Find latest Visual Studio installation and call devcmd
for /f "usebackq delims=" %%i in (`"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -prerelease -latest -property installationPath`) do (
  if exist "%%i\Common7\Tools\vsdevcmd.bat" (
    call "%%i\Common7\Tools\vsdevcmd.bat"
    goto clink
  )
)

rem VS not found — show error
color 4f
echo ERROR: Visual Studio installation not found ¯\_(ツ)_/¯
title ERROR
goto :eof

:clink
rem Prepend custom tools to PATH
set PATH=%BASE%bin;%BASE%nvim-win64\bin;%BASE%mingit\cmd;%BASE%clink;%BASE%busybox;%BASE%zig;%PATH%
set "CLINK_PATH=%BASE%clink\scripts"

rem Git config
set "GIT_CONFIG_COUNT=1"
set "GIT_CONFIG_KEY_0=include.path"
set "GIT_CONFIG_VALUE_0=%BASE%gitconfig"

rem Editor and FZF
set "EDITOR=nvim"
set "FZF_DEFAULT_COMMAND=fd --color never --type f --hidden --ignore-file %BASE%nvim-win64\share\nvim\.fd-ignore"

rem Define doskey macros for the session
doskey j=zoxide query $*
doskey ff=fzf $*
doskey ls=lsd $*
doskey cat=bat --paging=never $*
doskey gds=git diff --cached $*
doskey gdm=git diff origin/main $*

rem Inject clink and configure prompt
"%BASE%clink\clink_x64.exe" inject
"%BASE%clink\clink_x64.exe" config prompt use oh-my-posh
"%BASE%clink\clink_x64.exe" set ohmyposh.theme "%BASE%config\xyz.omp.json"

echo Developer environment ready!
goto :eof
