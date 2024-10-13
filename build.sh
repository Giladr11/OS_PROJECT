#!/bin/bash
export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

make all

echo "=============================================================="

echo "Calculating Kernel Checksum ->
"

echo "./build/boot/stage2/include/crc32_calc_file.exe > build/boot/stage2/include/kernel_crc32_result.txt"

echo ""

./build/boot/stage2/include/kernel_crc32_calc.exe > build/boot/stage2/include/kernel_crc32_result.txt

