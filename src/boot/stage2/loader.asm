;Main loader
[ORG 0x8000]
[BITS 16]

KERNEL_LOAD_SEG equ 0x1000

_start: 
    mov ax, 0x8000
    mov ds, ax
    mov ss, ax
    mov es, ax

    mov sp, 0x7FFF 

    call load_kernel
    
    mov esi, kernel_buffer
    call _start_crc32

    jmp load_pm

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

print_kernel_msg:
    mov si, load_kernel_message
    call print
    ret

print_disk_error:
    mov si, disk_error_message
    call print             
    hlt                          

kernel_buffer db "CRC32 Input", 0
load_kernel_message db "Loading Kernel to RAM..."  , 0x0D, 0x0A, 0
disk_error_message  db "Error Reading Disk..."     , 0x0D, 0x0A, 0

%include "src/boot/stage2/include/initpm.asm"
%include "src/boot/stage2/include/crc32.asm"
%include "src/boot/print16.asm"

times 1536-($-$$) db 0
