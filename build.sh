#!/bin/bash
set -euo pipefail

OUT="./build_output"
mkdir -p $OUT

# BUILD libasm.a - need to use .a extension to make jai's #foreign_lib happy
nasm -f elf64 -o $OUT/libasm.a lib.asm

# BUILD main_asm (link w/ libasm)
nasm -f elf64 -o $OUT/main_asm.o main.asm
ld -o $OUT/main_asm $OUT/main_asm.o $OUT/libasm.a

# BUILD libc.o - need to use .a extension to make jai's #foreign_lib happy
g++ -c -o $OUT/libcpp.a lib.cpp

# BUILD libjai.a and main_jai
touch "$OUT/libjai.a" # TODO(ryan): remove after jai-linux update
jai builder.jai

# BUILD main_c (link w/ libjai and libasm)
g++ -static -g -o $OUT/main_cpp \
  main.cpp $OUT/libasm.a $OUT/libjai.a -lpthread

if [[ "${1:-}" == 'test' ]]; then
  echo -e "\n=========================="
  echo -e   "          TESTS           "
  echo -e   "=========================="
  echo -e "\nmain_asm:"
  $OUT/main_asm
  echo -e "\nmain_cpp:"
  $OUT/main_cpp
  echo -e "\nmain_jai:"
  $OUT/main_jai
fi
