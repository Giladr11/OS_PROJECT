;Handling Checksums Verifications
[BITS 16]

section .data
    KERNEL_SIZE     equ 0x16C8

section .bss
    kernel_checksum_file_buffer resd 1
    kernel_checksum_result resd 1
    kernel_buffer resb 0x16C8


section .text
calc_kernel_checksum:
    mov esi, kernel_buffer
    mov ecx, KERNEL_SIZE 
    
    call _start_crc32
    
    mov [kernel_checksum_result], ebx 

    ret

compare_checksums:
    mov edx, [kernel_checksum_result]
    mov ecx, 0x26422D63

    cmp edx, ecx
    jne print_not_equal

    ret

print_not_equal:
    mov si, checksums_not_equal
    call print

    jmp $

checksums_not_equal db "Error: Kernel Checksums Do not Match!", 0x0D, 0x0A, 0x0D, 0x0A, 0


%include "src/boot/stage2/include/crc32.asm"
%include "src/boot/print16.asm"