#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

DESTDIR=""
IS_OSX=0

if [[ "$(uname)" == "Darwin" ]]; then
  DESTDIR="$(realpath $1)"
  IS_OSX=1
else
  DESTDIR="$(readlink -e $1)"
fi

DESTDIR="$(realpath $1)"

mkdir -p $DESTDIR/bin
mkdir -p $DESTDIR/lib
cp llvm-project/lldb/LICENSE.TXT $DESTDIR

cmake -S llvm-project/llvm -DCMAKE_BUILD_TYPE=Release -DLLDB_INCLUDE_TESTS=OFF -DLLVM_ENABLE_PROJECTS="clang;lldb" -G Ninja -B build-lldb
cmake --build build-lldb --target lldb-dap
cmake --build build-lldb --target lldb-server
cmake --build build-lldb --target lldb

#FOR OSX
if [[ $IS_OSX -eq 1 ]]; then
  cp build-lldb/lib/liblldb.* $DESTDIR/lib
else
  cp build-lldb/lib/liblldb.* $DESTDIR/bin
fi

cp build-lldb/bin/lldb-dap $DESTDIR/bin
cp build-lldb/bin/lldb-server $DESTDIR/bin
cp build-lldb/bin/lldb-argdumper $DESTDIR/bin
cp build-lldb/bin/lldb $DESTDIR/bin

if [[ $IS_OSX -eq 0 ]]; then
  patchelf --set-rpath '$ORIGIN' $DESTDIR/bin/lldb-dap
  patchelf --set-rpath '$ORIGIN' $DESTDIR/bin/lldb
fi
