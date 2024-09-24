[ORG 0x7C00]         ; Bootloader loads at memory address 0x7C00
[BITS 16]             ; Bootloader runs in 16-bit real mode

_start:
    ;restart segments
    mov ax, 0
    mov ds, ax
    mov es, ax
    jmp load_kernel


load_kernel:
    mov ah, 0x02 ;reads data from a drive
    mov al, 0x01 ;number of sectors
    mov ch, 0x00 ;cylinder number
    mov cl, 0x02 ;sector number
    mov dh, 0x00 ;head number
    mov dl, 0x80 ;drive number
    mov bx, 0x1000 ;load kernel at memory address 0x1000
    mov es, bx
    int 0x13 ;Bios interrupt for reading from disk
    jc disk_error

    jmp 0x1000:0x0000

disk_error:
    mov si, disk_error_message
    call print

print:
    mov ah, 0x0E

.read_char:
    lodsb ; loads si register to al char by char
    cmp al, 0
    je .done
    int 0x10 ; Call Bios interrupt to set video mode
    jmp .read_char
.done:
    hlt

disk_error_message db "Error Reading the USB Stick...", 0

times 510-($-$$) db 0  ; Subtracts the number of current bytes from 510 and fills the memory
dw 0xAA55              ; 2 bytes for Boot sector signature
