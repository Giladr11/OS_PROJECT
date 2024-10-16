#!/bin/bash
export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

make all

echo "=============================================="

echo "Calculating Kernel's Checksum ->
"

output=$(./build/boot/stage2/include/preboot_crc32_calc.exe)

echo -n $output | xxd -r -p > build/boot/stage2/crc32/preboot_crc32_result.bin
