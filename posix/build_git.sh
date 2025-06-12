#!/usr/bin/env bash
set -euo pipefail

# === Versions ===
GIT_VERSION="2.49.0"
CURL_VERSION="8.14.1"
WOLFSSL_VERSION="5.8.0"
ZLIB_VERSION="2.2.4"
EXPAT_VERSION="2.7.1"

BUILD_DIR="$PWD/git-build"
INSTALL_DIR="$BUILD_DIR/install"
TAR_NAME="git-${GIT_VERSION}-static.tar.gz"
TAR_PATH="$(dirname "$INSTALL_DIR")/$TAR_NAME"

# Clean start
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo "==> Building zlib-ng..."
mkdir -p zlib-src
curl -sL "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/${ZLIB_VERSION}.tar.gz" | tar xfz - --strip=1 -C zlib-src
cmake -S zlib-src -Bbuild-zlib -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_SHARED_LIBS=OFF -DZLIB_COMPAT=ON -DZLIB_ENABLE_TESTS=OFF -DZLIBNG_ENABLE_TESTS=OFF
cmake --build build-zlib
cmake --install build-zlib

echo "==> Building expat..."
mkdir -p expat-src
curl -sL "https://github.com/libexpat/libexpat/releases/download/R_${EXPAT_VERSION//./_}/expat-${EXPAT_VERSION}.tar.gz" | tar xfz - --strip=1 -C expat-src
cmake -S expat-src  -Bbuild-expat -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_SHARED_LIBS=OFF
cmake --build build-expat
cmake --install build-expat

echo "==> Building WolfSSL with OpenSSL compatibility..."
mkdir -p wolfssl-src
curl -sL "https://github.com/wolfSSL/wolfssl/archive/refs/tags/v${WOLFSSL_VERSION}-stable.tar.gz" | tar xfz - --strip=1 -C wolfssl-src
cmake -Swolfssl-src -Bbuild-wolfssl -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_SHARED_LIBS=OFF -DWOLFSSL_CURL=ON
cmake --build build-wolfssl
cmake --install build-wolfssl

echo "==> Building curl with WolfSSL and static libraries..."
mkdir -p curl-src
curl -sL "https://curl.se/download/curl-${CURL_VERSION}.tar.gz" | tar xfz - --strip=1 -C curl-src
cmake  -Scurl-src -Bbuild-curl -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_SHARED_LIBS=OFF -DCURL_USE_LIBPSL=OFF -DCURL_USE_WOLFSSL=ON
# cmake  -Scurl-src -Bbuild-curl -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_SHARED_LIBS=OFF -DCURL_USE_LIBPSL=OFF -DCURL_USE_WOLFSSL=ON -DCURL_USE_SECTRANSP=ON
cmake --build build-curl
cmake --install build-curl

echo "==> Building Git statically with curl, zlib, expat, and WolfSSL..."
mkdir -p git-src
curl -sL "https://github.com/git/git/archive/refs/tags/v${GIT_VERSION}.tar.gz" | tar xfz - --strip=1 -C git-src
cd git-src

make -j6 NO_TCLTK=YesPlease NO_GETTEXT=YesPlease NO_OPENSSL=YesPlease \
  CURLDIR="$INSTALL_DIR" ZLIB_PATH="$INSTALL_DIR" EXPAT_PATH="$INSTALL_DIR" \
  prefix='/git' NO_INSTALL_HARDLINKS=YesPlease \
  CURL_LDFLAGS="-L$INSTALL_DIR/install/lib -lcurl -lwolfssl -lm" DESTDIR="$INSTALL_DIR" install

# NOTE:
# set GIT_TEMPLATE_DIR properly

tar -C "$INSTALL_DIR" -czf "$TAR_PATH" git
echo "📦 Archive created at: $TAR_PATH"
