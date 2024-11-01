#!/bin/bash
set -euo pipefail
shopt -s nullglob globstar
DESTDIR="$(readlink -e $1)"

# git clone --depth 1 https://github.com/llvm/llvm-project
cmake -S llvm-project/llvm -DLLVM_TARGETS_TO_BUILD="X86" -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS="clang;lldb" -G Ninja -B build-lldb
cmake --build build-lldb --target lldb-dap
cmake --build build-lldb --target lldb-server
cmake --build build-lldb --target lldb
cp build-lldb/lib/liblldb.so* $DESTDIR
cp build-lldb/bin/lldb-dap $DESTDIR
cp build-lldb/bin/lldb-server $DESTDIR
cp build-lldb/bin/lldb-argdumper $DESTDIR
cp build-lldb/bin/lldb $DESTDIR
patchelf --set-rpath '$ORIGIN' $DESTDIR/lldb-dap
patchelf --set-rpath '$ORIGIN' $DESTDIR/lldb
