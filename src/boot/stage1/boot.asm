[ORG 0x7C00]                    ; Bootloader loads at memory address 0x7C00
[BITS 16]                       ; Bootloader runs in 16-bit real mode

STAGE2_LOAD_SEG equ 0x8C00
STAGE2_ENTRY_OFFSET equ 0x0000

_start:
    mov ax, 0x7C00              ; Set segments to 0x7C00 where the stage1 is loaded
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov bp, 0x7C00
    mov sp, 0x7D00                  

    call load_stage2
    jmp STAGE2_LOAD_SEG:STAGE2_ENTRY_OFFSET

load_stage2:
    call disk_error
    mov ah, 0x02                ; Function: Read Sectors
    mov dl, 0x80                ; Drive number
    mov dh, 0x00                ; Head number
    mov ch, 0x00                ; Cylinder number (0)
    mov cl, 0x02                ; Sector number (2)
    mov al, 0x01                ; Number of sectors to read (1)
    mov bx, STAGE2_LOAD_SEG     ; Load kernel at memory address 0x1000
    mov es, bx                  ; Set ES to the load address
    int 0x13                    ; BIOS interrupt to read from disk
    jc disk_error               ; Jump to error handling if carry flag is set

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

disk_error_message db "Error Reading the USB Stick...", 0

times 510-($-$$) db 0          ; Fill up the remaining bytes with 0
dw 0xAA55                      ; Boot sector signature bytes
