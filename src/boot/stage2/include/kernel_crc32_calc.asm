
TOTAL_SECTORS equ 0x0C
KERNEL_SIZE   equ 5832
sector_number db 0x07

section .bss
    kernel_buffer resb KERNEL_SIZE 
    checksum_buffer resd 1

section .text
    global _start 

_start:
    mov cx, TOTAL_SECTORS

    call read_kernel

read_kernel:
    ; mov ah, 0x02                    
    ; mov dl, 0x80                    
    ; mov dh, 0x00                    
    ; mov ch, 0x00                    
    ; mov cl, [sector_number]              
    ; mov al, 0x01                  
    ; mov bx, 
    ; mov es, [kernel_buffer]
    ; int 0x13

    ; inc byte [sector_number]
    ; jmp read_kernel
    ret


%include "src/boot/stage2/include/crc32.asm"
%include "src/boot/print16.asm"
