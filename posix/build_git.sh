#!/usr/bin/env bash
set -euo pipefail

# === Versions ===
GIT_VERSION="2.49.0"
CURL_VERSION="8.14.1"
ZLIB_VERSION="2.2.4"
EXPAT_VERSION="2.7.1"
OPENSSL_VERSION="3.3.3"

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
cmake -S zlib-src -Bbuild-zlib -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_SHARED_LIBS=OFF -DZLIB_COMPAT=ON -DZLIB_ENABLE_TESTS=OFF -DZLIBNG_ENABLE_TESTS=OFF
cmake --build build-zlib
cmake --install build-zlib

echo "==> Building expat..."
mkdir -p expat-src
curl -sL "https://github.com/libexpat/libexpat/releases/download/R_${EXPAT_VERSION//./_}/expat-${EXPAT_VERSION}.tar.gz" | tar xfz - --strip=1 -C expat-src
cmake -S expat-src  -Bbuild-expat -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_SHARED_LIBS=OFF
cmake --build build-expat
cmake --install build-expat

echo "==> Building OpenSSL ..."
mkdir -p openssl-src
curl -sL https://github.com/viaduck/openssl-cmake/archive/refs/heads/v3.tar.gz  | tar xfz - --strip=1 -C openssl-src
cmake -Sopenssl-src -Bbuild-openssl -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_SHARED_LIBS=OFF -DBUILD_OPENSSL=ON -DOPENSSL_BUILD_VERSION="$OPENSSL_VERSION"
cmake --build build-openssl
cmake --install build-openssl

rm "$INSTALL_DIR"/lib/*.so

echo "==> Building curl and static libraries..."
mkdir -p curl-src
curl -sL "https://curl.se/download/curl-${CURL_VERSION}.tar.gz" | tar xfz - --strip=1 -C curl-src
cmake  -Scurl-src -Bbuild-curl -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_SHARED_LIBS=OFF -DCURL_USE_LIBPSL=OFF -DCURL_DISABLE_NTLM=ON
cmake --build build-curl
cmake --install build-curl

echo "==> Building Git statically with curl, zlib, expat, and openssl..."
mkdir -p git-src
curl -sL "https://github.com/git/git/archive/refs/tags/v${GIT_VERSION}.tar.gz" | tar xfz - --strip=1 -C git-src
cd git-src

CURL_BUILD_FLAGS=$("$INSTALL_DIR"/bin/curl-config --libs)
make -j6 NO_TCLTK=YesPlease NO_GETTEXT=YesPlease NO_OPENSSL=YesPlease USE_CURL_FOR_IMAP_SEND=YesPlease \
  CURLDIR="$INSTALL_DIR" ZLIB_PATH="$INSTALL_DIR" EXPAT_PATH="$INSTALL_DIR" \
  prefix='/git' NO_INSTALL_HARDLINKS=YesPlease \
  CURL_LDFLAGS="$CURL_BUILD_FLAGS" DESTDIR="$INSTALL_DIR" install

tar -C "$INSTALL_DIR" -czf "$TAR_PATH" git
echo "📦 Archive created at: $TAR_PATH"
echo "Set GIT_EXEC_PATH to {prefix}/git/libexec/git-core"
echo "Set GIT_TEMPLATE_DIR to {prefix}/git/share/git-core/templates"
