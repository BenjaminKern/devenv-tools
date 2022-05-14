@echo off
setlocal enableextensions

set DESTDIR=%1
mkdir %DESTDIR%\bin
mkdir %DESTDIR%\mingit
mkdir %DESTDIR%\neovim
mkdir %DESTDIR%\busybox
mkdir %DESTDIR%\clink
mkdir %DESTDIR%\clink\scripts
mkdir %DESTDIR%\cmake
mkdir %DESTDIR%\clangd
mkdir %DESTDIR%\python
mkdir %DESTDIR%\cpptools

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
tar xf clangd.zip --strip-components=1 -C %DESTDIR%\clangd
echo "Downloading clangd indexer..."
curl -sL https://github.com/clangd/clangd/releases/download/14.0.0/clangd_indexing_tools-windows-14.0.0.zip -o clangd_indexing_tools.zip
tar xf clangd_indexing_tools.zip --strip-components=1 -C %DESTDIR%\clangd
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
tar xf cmake.zip --strip-components=1 -C %DESTDIR%\cmake
echo "Download starship..."
curl -sL https://github.com/starship/starship/releases/download/v1.6.3/starship-x86_64-pc-windows-msvc.zip -o starship.zip
tar xf starship.zip -C %DESTDIR%\bin
echo "Download python..."
curl -sL https://www.python.org/ftp/python/3.10.4/python-3.10.4-embed-amd64.zip -o python.zip
tar xf python.zip -C %DESTDIR%\python
echo "Download ninja..."
curl -sL https://github.com/ninja-build/ninja/releases/download/v1.10.2/ninja-win.zip -o ninja.zip
tar xf ninja.zip -C %DESTDIR%\bin
echo "Download vscode cpptools..."
curl -LsO https://github.com/microsoft/vscode-cpptools/releases/download/v1.9.8/cpptools-win64.vsix
tar xf cpptools-win64.vsix --strip-components=1 -C %DESTDIR%\cpptools
echo "Setup busybox..."
copy /y %DESTDIR%\mingit\mingw64\bin\busybox.exe %DESTDIR%\busybox\
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/windows/busybox_template.bat -o %DESTDIR%\busybox_template.bat
:: copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\[.bat
:: copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\[[.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\ar.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\arch.bat
:: copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\ash.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\awk.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\base64.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\basename.bat
:: copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\bash.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\bunzip2.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\busybox.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\bzcat.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\bzip2.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\cal.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\cat.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\chmod.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\cksum.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\clear.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\cmp.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\comm.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\cp.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\cpio.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\cut.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\date.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\dc.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\dd.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\df.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\diff.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\dirname.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\dos2unix.bat
:: copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\dpkg-deb.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\du.bat
:: copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\echo.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\ed.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\egrep.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\env.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\expand.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\expr.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\factor.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\false.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\fgrep.bat
:: copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\find.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\fold.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\ftpget.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\ftpput.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\getopt.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\grep.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\groups.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\gunzip.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\gzip.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\hd.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\head.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\hexdump.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\id.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\ipcalc.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\kill.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\killall.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\less.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\link.bat
:: copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\ln.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\logname.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\ls.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\lzcat.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\lzma.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\lzop.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\lzopcat.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\man.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\md5sum.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\mkdir.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\mktemp.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\mv.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\nc.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\nl.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\od.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\paste.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\patch.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\pgrep.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\pidof.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\printenv.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\printf.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\ps.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\pwd.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\rev.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\rm.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\rmdir.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\rpm.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\rpm2cpio.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\sed.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\seq.bat
:: copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\sh.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\sha1sum.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\sha256sum.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\sha3sum.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\sha512sum.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\shuf.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\sleep.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\sort.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\split.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\stat.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\strings.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\sum.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\tac.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\tail.bat
:: copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\tar.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\tee.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\test.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\timeout.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\touch.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\tr.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\true.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\truncate.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\uname.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\uncompress.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\unexpand.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\uniq.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\unix2dos.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\unlink.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\unlzma.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\unlzop.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\unxz.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\unzip.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\usleep.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\uudecode.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\uuencode.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\watch.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\wc.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\wget.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\which.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\whoami.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\whois.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\xargs.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\xxd.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\xz.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\xzcat.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\yes.bat
copy /y %DESTDIR%\busybox_template.bat %DESTDIR%\busybox\zcat.bat
