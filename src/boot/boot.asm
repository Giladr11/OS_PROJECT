[BITS 16]             ; Bootloader runs in 16-bit real mode
[ORG 0x7C00]         ; Bootloader loads at memory address 0x7C00

start:
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov si, boot_message
    call read_from_usb_stick

read_from_usb_stick:
    mov ah, 0x02 ; reads data from a drive
    mov al, 10 ; number of sectors
    mov ch, 0 ; cylinder number
    mov cl, 36 ; sector number
    int 0x13 ; Bios interrupt for reading from disk

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

boot_message db "System has booted Successfully!!", 0

times 510-($-$$) db 0  ; Subtracts the number of current bytes from 510 and fills the memory
dw 0xAA55              ; 2 bytes for Boot sector signature
