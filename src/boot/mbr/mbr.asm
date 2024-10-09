;Main Stage1
[ORG 0x7C00]
[BITS 16]

STAGE2_LOAD_SEG equ 0x6000
STAGE2_OFFSET equ 0x0000

_START:
    xor ax, ax                 
    mov ds, ax
    mov es, ax                   
    mov ss, ax
    mov sp, 0x7BFF
    
    call INIT_BOOT_MESSAGE

    call LOAD_STAGE2
    jmp STAGE2_LOAD_SEG:STAGE2_OFFSET
    
LOAD_STAGE2:
    call STAGE2_MESSAGE

    mov ah, 0x02                    ; Read Sectors
    mov dl, 0x80                    ; Drive number
    mov dh, 0x00                    ; Head number
    mov ch, 0x00                    ; Cylinder number
    mov cl, 0x02                    ; Sector number
    mov al, 0x01                    ; Number of sectors to read
    mov bx, STAGE2_LOAD_SEG         ; Set Memory address to load Stage2
    mov es, bx                      ; Set Extra segment to the load address
    int 0x13                        ; BIOS interrupt to read from disk
    jc DISK_ERROR                   
    ret

INIT_BOOT_MESSAGE:
    mov si, init_boot_message
    call PRINT
    ret

STAGE2_MESSAGE:
    mov si, stage2_message
    call PRINT
    ret

DISK_ERROR:
    mov si, disk_error_message
    call PRINT           
    hlt                          

init_boot_message  db "Initializing Booting Process..." , 0x0D, 0x0A, 0
stage2_message     db "Loading Stage2..."               , 0x0D, 0x0A, 0 
disk_error_message db "Error Reading Disk..."           , 0x0D, 0x0A, 0

%include "src/boot/PRINT16.asm"

times 510-($-$$) db 0
dw 0xAA55
