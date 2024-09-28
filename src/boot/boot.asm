[ORG 0x7C00]                    ; Bootloader loads at memory address 0x7C00
[BITS 16]                       ; Bootloader runs in 16-bit real mode

KERNEL_LOAD_SEG equ 0x1000
KERNEL_ENTRY_OFFSET equ 0x0000

%include "src/boot/include/INITPM.asm"

_start:
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov bp, 0x7C00              ; Set stack pointer to the top of the bootloader
    mov sp, bp                  ; Set stack pointer to the top of the bootloader

    jmp load_kernel

load_kernel:
    mov bx, KERNEL_LOAD_SEG     ; Load kernel at memory address 0x1000
    mov dh, 0x00                ; Head number
    mov dl, 0x80                ; Drive number (first hard disk)
    mov cl, 0x02                ; Sector number
    mov ch, 0x00                ; Cylinder number
    mov ah, 0x02                ; BIOS read from drive
    mov al, 0x01                ; Number of sectors to read
    mov es, bx                  ; Set ES to the load address
    int 0x13                    ; BIOS interrupt to read from disk
    jc disk_error               ; Jump to error handling if carry flag is set

    jmp ENTER_PM

disk_error:
    mov si, disk_error_msg      ; Point to the error message
    call print                  ; Print the error message
    hlt                         ; Halt the CPU    

print:
    mov ah, 0x0E                ; Set function for teletype output
.read_char:
    lodsb                       ; Load character from DS:SI into AL
    cmp al, 0                   ; Check for null terminator
    je .done
    int 0x10                    ; Call BIOS interrupt to print character in AL
    jmp .read_char              ; Repeat for next character
.done:
    ret                         ; Return from print

disk_error_msg db "Error Reading the USB Stick...", 0

times 510-($-$$) db 0          ; Fill up the remaining bytes with 0
dw 0xAA55                      ; Boot sector signature bytes
