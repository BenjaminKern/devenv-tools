#!/usr/bin/env bash
set -euo pipefail

# === Versions ===
GIT_VERSION="2.49.0"
CURL_VERSION="8.14.1"
WOLFSSL_VERSION="5.8.0"
ZLIB_VERSION="1.3.1"
EXPAT_VERSION="2.7.1"

BUILD_DIR="$PWD/git-build"
INSTALL_DIR="$BUILD_DIR/install"
NUM_CPUS=$(nproc || sysctl -n hw.ncpu)

# Clean start
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"


# TODO: use zlib-ng
echo "==> Building zlib..."
curl -LO "https://zlib.net/zlib-${ZLIB_VERSION}.tar.gz"
tar xf "zlib-${ZLIB_VERSION}.tar.gz"
cd "zlib-${ZLIB_VERSION}"
cmake -Bbuild -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_SHARED_LIBS=OFF
cmake --build build
cmake --install build
cd ..

echo "==> Building expat..."
curl -LO "https://github.com/libexpat/libexpat/releases/download/R_${EXPAT_VERSION//./_}/expat-${EXPAT_VERSION}.tar.gz"
tar xf "expat-${EXPAT_VERSION}.tar.gz"
cd "expat-${EXPAT_VERSION}"
cmake -Bbuild -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_SHARED_LIBS=OFF
cmake --build build
cmake --install build
cd ..

echo "==> Building WolfSSL with OpenSSL compatibility..."
curl -LO "https://github.com/wolfSSL/wolfssl/archive/refs/tags/v${WOLFSSL_VERSION}-stable.tar.gz"
tar xf "v${WOLFSSL_VERSION}-stable.tar.gz"
cd "wolfssl-${WOLFSSL_VERSION}-stable"
cmake -Bbuild -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_SHARED_LIBS=OFF -DWOLFSSL_CURL=ON
cmake --build build
cmake --install build
cd ..

echo "==> Building curl with WolfSSL and static libraries..."
curl -LO "https://curl.se/download/curl-${CURL_VERSION}.tar.gz"
tar xf "curl-${CURL_VERSION}.tar.gz"
cd "curl-${CURL_VERSION}"
cmake -Bbuild -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_SHARED_LIBS=OFF -DCURL_USE_LIBPSL=OFF -DCURL_USE_WOLFSSL=ON
cmake --build build
cmake --install build
cd ..

echo "==> Building Git statically with curl, zlib, expat, and WolfSSL..."
curl -LO "https://github.com/git/git/archive/refs/tags/v${GIT_VERSION}.tar.gz"
tar xf "v${GIT_VERSION}.tar.gz"
cd "git-${GIT_VERSION}"

# TODO: make install target correct
make -j"$NUM_CPUS" NO_TCLTK=YesPlease NO_GETTEXT=YesPlease NO_OPENSSL=YesPlease \
  CURLDIR="$INSTALL_DIR" ZLIB_PATH="$INSTALL_DIR" EXPAT_PATH="$INSTALL_DIR" \
  CURL_LDFLAGS="-L$INSTALL_DIR/install/lib -lcurl -lwolfssl -lm" DESTDIR="$INSTALL_DIR" install

echo "✅ Git static build complete!"
ls -lh "$INSTALL_DIR/bin/git"
"$INSTALL_DIR/bin/git" --version
