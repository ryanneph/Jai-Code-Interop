#!/bin/bash

OUT="./build_output"
mkdir -p $OUT

# BUILD libjai.a
touch "$OUT/libjai.a" # TODO(ryan): remove after jai-linux update
jai builder.jai

# BUILD libasm.o
nasm -f elf64 -o $OUT/libasm.o lib.asm

# BUILD main_c (link w/ libjai and libasm)
g++ -static -g -o $OUT/main_c \
  main.cpp $OUT/libasm.o $OUT/libjai.a -lpthread
