;Pre-Boot CRC-32 Checksum Calculation

section .text
    global _start

_start:
    ret


%include "src/boot/stage2/include/crc32.asm"
%include "src/boot/print16.asm"
