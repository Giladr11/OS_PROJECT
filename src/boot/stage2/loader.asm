;Main loader
[ORG 0x8000]
[BITS 16]
    
_start: 
    mov ax, 0x8000
    mov ds, ax
    mov ss, ax
    mov es, ax

    mov sp, 0x7FFF 

    ;call print_press_key

    ;call wait_for_key

    call load_kernel
    
    call print_start_checksum_message

    call calc_kernel_checksum
    
    call open_kernel_checksum

    call read_kernel_checksum

    call compare_checksums

    jmp load_pm

wait_for_key:
    mov ah, 0x00
    int 0x16

    cmp ah, 0x1C
    jne wait_for_key

    ret

load_kernel:
    call print_kernel_msg

    mov ah, 0x02                    ; Read Sectors
    mov dl, 0x80                    ; Drive number
    mov dh, 0x00                    ; Head number
    mov ch, 0x00                    ; Cylinder number
    mov cl, 0x07                    ; Sector number
    mov al, 0x0C                    ; Number of sectors to read
    
    mov bx, KERNEL_LOAD_SEG         ; Set Memory address to load Kernel
    mov es, bx                      ; Set Extra segment to the load address
    
    int 0x13                        ; BIOS interrupt to read from disk
    
    jc print_disk_error  
                    
    ret

calc_kernel_checksum:
    mov esi, KERNEL_LOAD_SEG
    mov ecx, KERNEL_SIZE 

    call _start_crc32

    mov [kernel_checksum_result1], ebx 

    ret

open_kernel_checksum:
    mov eax, 0x05
    mov ebx, kernel_checksum_filename
    mov ecx, 0x00
    int 0x80

    mov ebx, eax
    ret

read_kernel_checksum:
    mov eax, 0x03
    mov ecx, kernel_checksum_result2
    mov edx, 0x04
    int 0x80
    ret

compare_checksums:
    mov edx, [kernel_checksum_result1]
    mov ecx, [kernel_checksum_result2]

    cmp edx, ecx
    jne print_not_equal

    ret

print_press_key:
    mov si, press_load_kernel
    call print
    ret

print_start_checksum_message:
    mov si, checksum_start_msg
    call print
    ret

print_kernel_msg:
    mov si, load_kernel_message
    call print
    ret

print_not_equal:
    mov si, checksums_not_equal
    call print

    jmp $

print_disk_error:
    mov si, disk_error_message
    call print             

    jmp $                        


KERNEL_LOAD_SEG equ 0x1000
KERNEL_SIZE equ 0x16C8
kernel_checksum_result1 dd 0
kernel_checksum_result2 dd 0
kernel_checksum_filename db "build/boot/stage2/crc32/kernel_result.bin", 0

press_load_kernel   db "Press Enter to Load The Kernel..."            , 0x0D, 0x0A, 0x0D, 0x0A, 0
load_kernel_message db "Loading The Kernel to RAM..."                 , 0x0D, 0x0A, 0x0D, 0x0A, 0
checksum_start_msg  db "Initiating Kernel Checksums Verifications..." , 0x0D, 0x0A, 0x0D, 0x0A, 0
checksums_not_equal db "Error: Kernel Checksums Do not Match!"        , 0x0D, 0x0A, 0x0D, 0x0A, 0
disk_error_message  db "Error: Reading Disk!"                         , 0x0D, 0x0A, 0x0D, 0x0A, 0


%include "src/boot/stage2/include/initpm.asm"
%include "src/boot/stage2/include/crc32.asm"
%include "src/boot/print16.asm"


times 1536-($-$$) db 0x0
