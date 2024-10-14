section .data
    kernel_filename db "build/kernel/kernel.bin", 0
    kernel_size equ 0x16C8
    hex_str db '0x00000000', 0
    result db "Kernel's CRC-32 Checksum: ", 0
    result_size equ 0x1A


section .bss
     kernel_buffer resb 0x16C8

section .text
    global _start 

_start:
    call open_kernel_bin

    call read_kernel_bin

    mov esi, kernel_buffer
    mov ecx, kernel_size
    
    call _start_crc32

    call to_hex

    call print_result_msg

    call print_hex
    
    call write_to_file

    call close_kernel_bin

    call exit

open_kernel_bin:
    mov eax, 0x05
    mov ebx, kernel_filename
    mov ecx, 0x00
    int 0x80

    mov ebx, eax
    ret

read_kernel_bin:
    mov eax, 0x03
    mov ecx, kernel_buffer
    mov edx, kernel_size
    int 0x80
    ret

close_kernel_bin:
    mov eax, 0x06
    int 0x80
    ret

write_to_file:
    mov ebx, 0x01
    mov eax, 0x04
    mov ecx, hex_str
    mov edx, 0x0A
    int 0x80
    ret

exit:
    mov eax, 0x01
    xor ebx, ebx
    int 0x80

print_result_msg:
    mov edx, result_size
    mov eax, 0x04
    mov ecx, result
    int 0x80
    ret

print_hex:
    mov edx, 0x0A
    mov eax, 0x04
    mov ecx, hex_str
    int 0x80
    ret

to_hex:
    mov ecx, 0x08
    mov edi, hex_str + 2

.to_hex_loop:
    dec ecx
    mov edx, ebx
    and edx, 0xF
    add edx, '0'

    cmp edx, '9'
    jbe .store_digit
    add edx, 0x07

.store_digit:
    mov [edi + ecx], dl
    shr ebx, 0x04
    
    test ebx, ebx
    jnz .to_hex_loop

    ret 

%include "src/boot/stage2/include/crc32.asm"
