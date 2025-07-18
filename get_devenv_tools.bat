@echo off
setlocal enableextensions

if "%~1"=="" (
    echo Usage: %~nx0 ^<install-dir^>
    exit /b 1
)
set "DESTDIR=%~1"

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
curl -sL https://github.com/BenjaminKern/devenv-tools/releases/download/v0.0.5/devenv-tools-x86_64-windows.tar.xz -o "%TEMP%\devenv-tools-x86_64-windows.tar.xz"
tar xf "%TEMP%\devenv-tools-x86_64-windows.tar.xz" --strip=1 -C "%DESTDIR%"
del "%TEMP%\devenv-tools-x86_64-windows.tar.xz"

echo Downloading configs...
mkdir "%DESTDIR%\config"
mkdir "%DESTDIR%\nvim-win64\share\nvim\runtime\snippets"
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/devenv_config.lua -o "%DESTDIR%\nvim-win64\share\nvim\runtime\lua\devenv_config.lua"
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/all.json -o "%DESTDIR%\nvim-win64\share\nvim\runtime\snippets\all.json"
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/cpp.json -o "%DESTDIR%\nvim-win64\share\nvim\runtime\snippets\cpp.json"
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/.fd-ignore -o "%DESTDIR%\nvim-win64\share\nvim\.fd-ignore"
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/refs/heads/main/.config/xyz.omp.json -o "%DESTDIR%\config\xyz.omp.json"

if not exist "%DESTDIR%\mingit" mkdir "%DESTDIR%\mingit"
echo Downloading mingit...
curl -sL https://github.com/git-for-windows/git/releases/download/v2.49.0.windows.1/MinGit-2.49.0-busybox-64-bit.zip -o "%TEMP%\mingit.zip"
tar xf "%TEMP%\mingit.zip" -C "%DESTDIR%\mingit"
del "%TEMP%\mingit.zip"

if not exist "%DESTDIR%\busybox" mkdir "%DESTDIR%\busybox"
copy /y %DESTDIR%\mingit\mingw64\bin\busybox.exe "%DESTDIR%\busybox\"

if not exist "%DESTDIR%\clink" mkdir "%DESTDIR%\clink"
echo Downloading clink...
curl -sL https://github.com/chrisant996/clink/releases/download/v1.7.19/clink.1.7.19.d8a218.zip -o "%TEMP%\clink.zip"
tar xf "%TEMP%\clink.zip" -C "%DESTDIR%\clink"
del "%TEMP%\clink.zip"

if not exist "%DESTDIR%\zig" mkdir "%DESTDIR%\zig"
echo Downloading zig...
curl -sL https://ziglang.org/download/0.14.1/zig-x86_64-windows-0.14.1.zip -o "%TEMP%\zig.zip"
tar xf "%TEMP%\zig.zip" --strip=1 -C "%DESTDIR%\zig"
del "%TEMP%\zig.zip"

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
