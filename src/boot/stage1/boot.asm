[ORG 0x7C00]
[BITS 16]

CODE_SEG equ 0x08
DATA_SEG equ 0x10
STAGE2_LOAD_SEG equ 0x2000
STAGE2_OFFSET equ 0x0000

_start:
    xor ax, ax                 
    mov ds, ax                   
    mov es, ax
    mov ss, ax
    mov sp, 0x7BFF
    
    mov si, boot_message
    call print 

    call load_stage2
    jmp STAGE2_LOAD_SEG:STAGE2_OFFSET
    
load_stage2:
    mov si, stage2_message
    call print

    mov ah, 0x02                    ; Function: Read Sectors
    mov dl, 0x80                    ; Drive number
    mov dh, 0x00                    ; Head number
    mov ch, 0x00                    ; Cylinder number (0)
    mov cl, 0x02                    ; Sector number (2)
    mov al, 0x01                    ; Number of sectors to read (1)
    mov bx, STAGE2_LOAD_SEG         ; Load kernel at memory address 0x1000
    mov es, bx                      ; Set ES to the load address
    int 0x13                        ; BIOS interrupt to read from disk
    jc disk_error                   ; Jump to error handling if carry flag is set
    ret

disk_error:
    mov si, disk_error_message
    call print             
    hlt                          

print:
    mov ah, 0x0E
.printchar:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .printchar
.done:
    ret

boot_message db "Starting Booting Process..."  , 0x0D, 0x0A, 0
stage2_message db "Switching to Stage2..."     , 0x0D, 0x0A, 0 
disk_error_message db "Error Reading Disk..."  , 0x0D, 0x0A, 0

times 510-($-$$) db 0
dw 0xAA55