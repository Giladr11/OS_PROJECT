#!/bin/bash
export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

make all

echo "=============================================="

echo "Calculating Kernel's Checksum ->
"

output=$(./build/boot/stage2/include/kernel_crc32_calc.exe)

hex_value=$(echo $output | grep -o '0x[0-9A-Fa-f]*')

echo -n $output | xxd -r -p > build/boot/stage2/checksum/kernel_crc32_result.bin
