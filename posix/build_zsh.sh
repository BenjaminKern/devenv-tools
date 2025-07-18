#!/usr/bin/env bash

set -euo pipefail

# === CONFIG ===
ZSH_VERSION="5.9"
NCURSES_VERSION="6.4"
PCRE2_VERSION="10.43"
ZLIB_VERSION="1.3"

BUILD_DIR="$PWD/zsh_build"
PREFIX_DIR="$PWD/zsh_static"
NUM_CORES=$(nproc)

mkdir -p "$BUILD_DIR" "$PREFIX_DIR"
cd "$BUILD_DIR"

export CC=gcc
export CFLAGS="-static -O2"
export PKG_CONFIG_PATH="$PREFIX_DIR/lib/pkgconfig"
export CPPFLAGS="-I$PREFIX_DIR/include"
export LDFLAGS="-L$PREFIX_DIR/lib"

# === FUNCTIONS ===

build_zlib() {
  curl -LO https://github.com/madler/zlib/releases/download/v${ZLIB_VERSION}/zlib-${ZLIB_VERSION}.tar.xz
  tar -xf zlib-${ZLIB_VERSION}.tar.xz
  cd zlib-${ZLIB_VERSION}
  ./configure --prefix="$PREFIX_DIR"
  make -j"$NUM_CORES"
  make install
  cd ..
}

build_ncurses() {
  curl -LO https://github.com/mirror/ncurses/archive/refs/tags/v${NCURSES_VERSION}.tar.gz
  tar -xzf v${NCURSES_VERSION}.tar.gz
  cd ncurses-${NCURSES_VERSION}
  ./configure \
    --prefix="$PREFIX_DIR" \
    --with-termlib \
    --with-normal \
    --without-shared \
    --enable-widec \
    --with-pkg-config-libdir="$PREFIX_DIR/lib/pkgconfig"
  make -j"$NUM_CORES"
  make install
  cd ..
}

build_pcre2() {
  curl -LO https://github.com/PhilipHazel/pcre2/releases/download/pcre2-${PCRE2_VERSION}/pcre2-${PCRE2_VERSION}.tar.gz
  tar -xzf pcre2-${PCRE2_VERSION}.tar.gz
  cd pcre2-${PCRE2_VERSION}
  ./configure \
    --prefix="$PREFIX_DIR" \
    --disable-shared \
    --enable-pcre2-8 \
    --enable-pcre2-16 \
    --enable-pcre2-32 \
    --enable-unicode
  make -j"$NUM_CORES"
  make install
  cd ..
}

build_zsh() {
  curl -LO https://github.com/zsh-users/zsh/archive/refs/tags/zsh-${ZSH_VERSION}.tar.gz
  tar -xzf zsh-${ZSH_VERSION}.tar.gz
  cd zsh-zsh-${ZSH_VERSION}
  ./Util/preconfig

  ./configure \
    --prefix="$PREFIX_DIR" \
    --disable-dynamic \
    --enable-multibyte \
    --enable-pcre \
    PCRE_CFLAGS="-I$PREFIX_DIR/include" \
    PCRE_LIBS="-L$PREFIX_DIR/lib -lpcre2-8" \
    --with-curses-terminfo \
    --disable-etcdir \
    --disable-fndir \
    --disable-scriptdir \
    --disable-site-fndir \
    --disable-site-scriptdir

  make -j"$NUM_CORES" all

  make install.bin install.modules install.fns
  cd ..
}

# === BUILD ===

echo "==> Building zlib..."
build_zlib

echo "==> Building ncurses..."
build_ncurses

echo "==> Building pcre2..."
build_pcre2

echo "==> Building static Zsh..."
build_zsh

# === DONE ===

tar cfz zsh-${ZSH_VERSION}-static.tar.gz -C "$PREFIX_DIR" bin/zsh share/terminfo/x

echo "📦 Static Zsh Archive created"
echo "Set TERMINFO to {prefix}/share/terminfo"

