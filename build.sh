#!/bin/bash
set -euo pipefail

OUT="./build_output"
mkdir -p $OUT

# BUILD libasm.o
nasm -f elf64 -o $OUT/libasm.a lib.asm

# BUILD libjai.a
touch "$OUT/libjai.a" # TODO(ryan): remove after jai-linux update
jai builder.jai

# BUILD main_c (link w/ libjai and libasm)
g++ -static -g -o $OUT/main_c \
  main.cpp $OUT/libasm.a $OUT/libjai.a -lpthread
