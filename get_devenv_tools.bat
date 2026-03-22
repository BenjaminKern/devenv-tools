@echo off
setlocal enableextensions

if "%~1"=="" (
    echo Usage: %~nx0 ^<install-dir^>
    exit /b 1
)
set "DESTDIR=%~1"

set "MINGIT_VERSION=2.49.0"
set "CLINK_VERSION=1.7.19"
set "CLINK_HASH=d8a218"
set "ZIG_VERSION=0.14.1"

where curl >nul 2>&1 || (
    echo Error: curl not found in PATH
    exit /b 1
)

where tar >nul 2>&1 || (
    echo Error: tar not found in PATH
    exit /b 1
)

if not exist "%DESTDIR%" mkdir "%DESTDIR%"

echo Downloading devenv tools...
curl -sL https://github.com/BenjaminKern/devenv-tools/releases/download/latest/devenv-tools-x86_64-windows.tar.xz -o "%TEMP%\devenv-tools-x86_64-windows.tar.xz" || goto :error
tar xf "%TEMP%\devenv-tools-x86_64-windows.tar.xz" --strip=1 -C "%DESTDIR%" || goto :error
del "%TEMP%\devenv-tools-x86_64-windows.tar.xz"

echo Downloading configs...
if not exist "%DESTDIR%\config" mkdir "%DESTDIR%\config"
if not exist "%DESTDIR%\nvim-win64\share\nvim\runtime\snippets" mkdir "%DESTDIR%\nvim-win64\share\nvim\runtime\snippets"
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/devenv_config.lua -o "%DESTDIR%\nvim-win64\share\nvim\runtime\lua\devenv_config.lua" || goto :error
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/all.json -o "%DESTDIR%\nvim-win64\share\nvim\runtime\snippets\all.json" || goto :error
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/cpp.json -o "%DESTDIR%\nvim-win64\share\nvim\runtime\snippets\cpp.json" || goto :error
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/.fd-ignore -o "%DESTDIR%\nvim-win64\share\nvim\.fd-ignore" || goto :error
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/refs/heads/main/.config/xyz.omp.json -o "%DESTDIR%\config\xyz.omp.json" || goto :error

if not exist "%DESTDIR%\mingit" mkdir "%DESTDIR%\mingit"
echo Downloading mingit...
curl -sL https://github.com/git-for-windows/git/releases/download/v%MINGIT_VERSION%.windows.1/MinGit-%MINGIT_VERSION%-busybox-64-bit.zip -o "%TEMP%\mingit.zip" || goto :error
tar xf "%TEMP%\mingit.zip" -C "%DESTDIR%\mingit" || goto :error
del "%TEMP%\mingit.zip"

if not exist "%DESTDIR%\busybox" mkdir "%DESTDIR%\busybox"
copy /y %DESTDIR%\mingit\mingw64\bin\busybox.exe "%DESTDIR%\busybox\" || goto :error

if not exist "%DESTDIR%\clink" mkdir "%DESTDIR%\clink"
echo Downloading clink...
curl -sL https://github.com/chrisant996/clink/releases/download/v%CLINK_VERSION%/clink.%CLINK_VERSION%.%CLINK_HASH%.zip -o "%TEMP%\clink.zip" || goto :error
tar xf "%TEMP%\clink.zip" -C "%DESTDIR%\clink" || goto :error
del "%TEMP%\clink.zip"

if not exist "%DESTDIR%\zig" mkdir "%DESTDIR%\zig"
echo Downloading zig...
curl -sL https://ziglang.org/download/%ZIG_VERSION%/zig-x86_64-windows-%ZIG_VERSION%.zip -o "%TEMP%\zig.zip" || goto :error
tar xf "%TEMP%\zig.zip" --strip=1 -C "%DESTDIR%\zig" || goto :error
del "%TEMP%\zig.zip"

echo Downloading devenv_tools.bat...
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/devenv_tools.bat -o "%DESTDIR%\devenv_tools.bat" || goto :error

echo Downloading gitconfig...
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/gitconfig -o "%DESTDIR%\gitconfig" || goto :error

set CMDLIST=cat cksum clear cp ls mv rm base64 cut env head tail md5sum mktemp realpath readlink sha256sum sleep split tee touch whoami yes wc pwd unzip

for %%C in (%CMDLIST%) do (
    (
        echo @echo off
        echo setlocal
        echo %%~dp0\busybox.exe %%~n0 %%*
    ) > "%DESTDIR%\busybox\%%C.bat"
)

echo.
echo Setup complete! Tools installed to: "%DESTDIR%"
echo Add 'cmd.exe /k "%DESTDIR%"\devenv_tools.bat' to Command Line command
echo Add the following line to %LOCALAPPDATA%\nvim\init.lua
echo require('devenv_config'^)
exit /b 0

:error
echo ERROR: A download or extraction step failed.
exit /b 1
