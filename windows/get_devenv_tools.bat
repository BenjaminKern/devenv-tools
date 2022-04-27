@echo off
setlocal enableextensions

set DESTDIR=%1
mkdir %DESTDIR%\mingit
mkdir %DESTDIR%\neovim
mkdir %DESTDIR%\busybox
mkdir %DESTDIR%\clink

echo "Downloading devenv_tools config..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/windows/devenv_tools.bat -o %DESTDIR%\devenv_tools.bat
echo "Downloading nvim..."
curl -sL https://github.com/neovim/neovim/releases/download/nightly/nvim-win64.zip -o nvim.zip
tar xf nvim.zip --strip-components=1 -C %DESTDIR%\neovim
mkdir %DESTDIR%\neovim\share\nvim\sessions
mkdir %DESTDIR%\neovim\share\nvim\runtime\snippets
echo "Downloading vim plugged..."
curl -sL https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -o %DESTDIR%\neovim\share\nvim\runtime\pack\dist\opt\plug\plugin\plug.vim --create-dirs
echo "Downloading neovim config..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/devenv_config.lua -o %DESTDIR%\neovim\share\nvim\runtime\lua\devenv_config.lua
echo "Downloading neovim snippets..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/_.snippets -o %DESTDIR%\neovim\share\nvim\runtime\snippets\_.snippets
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/c.snippets -o %DESTDIR%\neovim\share\nvim\runtime\snippets\c.snippets
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/cpp.snippets -o %DESTDIR%\neovim\share\nvim\runtime\snippets\cpp.snippets
echo "Downloading fd ignore file..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/.fd-ignore -o %DESTDIR%\neovim\share\nvim\.fd-ignore
echo "Downloading clangd..."
curl -sL https://github.com/clangd/clangd/releases/download/14.0.0/clangd-windows-14.0.0.zip -o clangd.zip
tar xf clangd.zip --strip-components=1 -C %DESTDIR%
echo "Downloading clangd indexer..."
curl -sL https://github.com/clangd/clangd/releases/download/14.0.0/clangd_indexing_tools-windows-14.0.0.zip -o clangd_indexing_tools.zip
tar xf clangd_indexing_tools.zip --strip-components=1 -C %DESTDIR%
echo "Downloading ripgrep..."
curl -sL https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-pc-windows-msvc.zip | tar xf - --strip-components=1 -C %DESTDIR%\bin
echo "Downloading fzf..."
curl -sL https://github.com/junegunn/fzf/releases/download/0.30.0/fzf-0.30.0-windows_amd64.zip -o fzf.zip
tar xf fzf.zip -C %DESTDIR%\bin
echo "Downloading hexyl..."
curl -sL https://github.com/sharkdp/hexyl/releases/download/v0.9.0/hexyl-v0.9.0-x86_64-pc-windows-msvc.zip -o hexyl.zip
tar xf hexyl.zip --strip-components=1 -C %DESTDIR%\bin
echo "Downloading hyperfine..."
curl -sL https://github.com/sharkdp/hyperfine/releases/download/v1.12.0/hyperfine-v1.12.0-x86_64-pc-windows-msvc.zip -o hyperfine.zip
tar xf hyperfine.zip --strip-components=1 -C %DESTDIR%\bin
echo "Downloading fd..."
curl -sL https://github.com/sharkdp/fd/releases/download/v8.3.2/fd-v8.3.2-x86_64-pc-windows-msvc.zip -o fd.zip
tar xf fd.zip --strip-components=1 -C %DESTDIR%\bin
echo "Downloading bat..."
curl -sL https://github.com/sharkdp/bat/releases/download/v0.20.0/bat-v0.20.0-x86_64-pc-windows-msvc.zip -o bat.zip
tar xf bat.zip --strip-components=1 -C %DESTDIR%\bin
echo "Downloading dust..."
curl -sL https://github.com/bootandy/dust/releases/download/v0.8.0/dust-v0.8.0-x86_64-pc-windows-msvc.zip -o dust.zip
tar xf dust.zip --strip-components=1 -C %DESTDIR%\bin
echo "Downloading bottom..."
curl -sL https://github.com/ClementTsang/bottom/releases/download/0.6.8/bottom_x86_64-pc-windows-msvc.zip -o bottom.zip
tar xf bottom.zip -C %DESTDIR%\bin
echo "Downloading zoxide..."
curl -sL https://github.com/ajeetdsouza/zoxide/releases/download/v0.8.0/zoxide-v0.8.0-x86_64-pc-windows-msvc.zip -o zoxide.zip
tar xf zoxide.zip -C %DESTDIR%\bin
echo "Downloading gojq..."
curl -sL https://github.com/itchyny/gojq/releases/download/v0.12.7/gojq_v0.12.7_windows_amd64.zip -o gojq.zip
tar xf gojq.zip  --strip-components=1 -C %DESTDIR%\bin
echo "Downloading age..."
curl -sL https://github.com/FiloSottile/age/releases/download/v1.0.0/age-v1.0.0-windows-amd64.zip -o age.zip
tar xf age.zip --strip-components=1 -C %DESTDIR%\bin
echo "Downloading git..."
curl -sL https://github.com/git-for-windows/git/releases/download/v2.36.0.windows.1/MinGit-2.36.0-busybox-64-bit.zip -o mingit.zip
tar xf mingit.zip -C %DESTDIR%\mingit
echo "Downloading clink..."
curl -sL https://github.com/chrisant996/clink/releases/download/v1.3.15/clink.1.3.15.6e6e45.zip -o clink.zip
tar xf clink.zip -C %DESTDIR%\clink
echo "Download cmake..."
curl -sL https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-windows-x86_64.zip -o cmake.zip
tar xf cmake.zip --strip-components=1 -C %DESTDIR%
