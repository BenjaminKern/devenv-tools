@echo off
setlocal enableextensions

set DESTDIR=%1
mkdir %DESTDIR%\mingit
mkdir %DESTDIR%\neovim

echo "Downloading nvim..."
curl -sL https://github.com/neovim/neovim/releases/download/v0.5.1/nvim-win64.zip | tar xf - --strip-components=1 -C %DESTDIR%\neovim
echo "Downloading vim plugged..."
curl -sL https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -o %DESTDIR%\neovim\share\nvim\runtime\pack\dist\opt\plug\plugin\plug.vim --create-dirs
echo "Downloading neovim config..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/init.lua -o %DESTDIR%\neovim\share\nvim\runtime\lua\devenv_config.lua
echo "Downloading fd ignore file..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/devenv/.fd-ignore -o %DESTDIR%\neovim\share\nvim\.fd-ignore
echo "Downloading clangd..."
curl -sL https://github.com/clangd/clangd/releases/download/13.0.0/clangd-windows-13.0.0.zip | tar xf - --strip-components=1 -C %DESTDIR%
echo "Downloading clangd indexer..."
curl -sL https://github.com/clangd/clangd/releases/download/13.0.0/clangd_indexing_tools-windows-13.0.0.zip | tar xf - --strip-components=1 -C %DESTDIR%
echo "Downloading ripgrep..."
curl -sL https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-pc-windows-msvc.zip | tar xf - --strip-components=1 -C %DESTDIR%\bin
echo "Downloading fzf..."
curl -sLO https://github.com/junegunn/fzf/releases/download/0.27.3/fzf-0.27.3-windows_amd64.zip
tar xf fzf-0.27.3-windows_amd64.zip -C %DESTDIR%\bin
echo "Downloading hexyl..."
curl -sLO https://github.com/sharkdp/hexyl/releases/download/v0.9.0/hexyl-v0.9.0-x86_64-pc-windows-msvc.zip
tar xf hexyl-v0.9.0-x86_64-pc-windows-msvc.zip --strip-components=1 -C %DESTDIR%\bin
echo "Downloading hyperfine..."
curl -sLO https://github.com/sharkdp/hyperfine/releases/download/v1.12.0/hyperfine-v1.12.0-x86_64-pc-windows-msvc.zip
tar xf hyperfine-v1.12.0-x86_64-pc-windows-msvc.zip --strip-components=1 -C %DESTDIR%\bin
echo "Downloading fd..."
curl -sLO https://github.com/sharkdp/fd/releases/download/v8.2.1/fd-v8.2.1-x86_64-pc-windows-msvc.zip
tar xf fd-v8.2.1-x86_64-pc-windows-msvc.zip -C %DESTDIR%\bin
echo "Downloading bat..."
curl -sLO https://github.com/sharkdp/bat/releases/download/v0.18.3/bat-v0.18.3-x86_64-pc-windows-msvc.zip
tar xf bat-v0.18.3-x86_64-pc-windows-msvc.zip --strip-components=1 -C %DESTDIR%\bin
echo "Downloading lsd..."
curl -sLO https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd-0.20.1-x86_64-pc-windows-msvc.zip
tar xf lsd-0.20.1-x86_64-pc-windows-msvc.zip --strip-components=1 -C %DESTDIR%\bin
echo "Downloading dust..."
curl -sLO https://github.com/bootandy/dust/releases/download/v0.7.5/dust-v0.7.5-x86_64-pc-windows-msvc.zip
tar xf dust-v0.7.5-x86_64-pc-windows-msvc.zip --strip-components=1 -C %DESTDIR%\bin
echo "Downloading bottom..."
curl -sLO https://github.com/ClementTsang/bottom/releases/download/0.6.4/bottom_x86_64-pc-windows-msvc.zip
tar xf bottom_x86_64-pc-windows-msvc.zip -C %DESTDIR%\bin
echo "Downloading zoxide..."
curl -sLO https://github.com/ajeetdsouza/zoxide/releases/download/v0.7.7/zoxide-v0.7.7-x86_64-pc-windows-msvc.zip
tar xf zoxide-v0.7.7-x86_64-pc-windows-msvc.zip -C %DESTDIR%\bin
echo "Downloading gojq..."
curl -sLO https://github.com/itchyny/gojq/releases/download/v0.12.5/gojq_v0.12.5_windows_amd64.zip
tar xf gojq_v0.12.5_windows_amd64.zip  --strip-components=1 -C %DESTDIR%\bin
echo "Downloading age..."
curl -sLO https://github.com/FiloSottile/age/releases/download/v1.0.0/age-v1.0.0-windows-amd64.zip
tar xf age-v1.0.0-windows-amd64.zip --strip-components=1 -C %DESTDIR%\bin
echo "Downloading git..."
curl -sLO https://github.com/git-for-windows/git/releases/download/v2.33.1.windows.1/MinGit-2.33.1-busybox-64-bit.zip
tar xf MinGit-2.33.1-busybox-64-bit.zip -C %DESTDIR%\mingit
echo "Downloading clink..."
curl -sLO https://github.com/chrisant996/clink/releases/download/v1.2.37/clink.1.2.37.de5dfb.zip
tar xf clink.1.2.37.de5dfb.zip -C %DESTDIR%\bin
echo "Download cmake..."
curl -sLO https://github.com/Kitware/CMake/releases/download/v3.21.3/cmake-3.21.3-windows-x86_64.zip
tar xf cmake-3.21.3-windows-x86_64.zip --strip-components=1 -C %DESTDIR%
