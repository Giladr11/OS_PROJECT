[ORG 0x7C00]                    ; Bootloader loads at memory address 0x7C00
[BITS 16]                       ; Bootloader runs in 16-bit real mode

CODE_OFFSET equ 0x08
DATA_OFFSET equ 0x10

KERNEL_LOAD_SEG equ 0x1000

_start:
    cli                         ; Disable interrupts
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00              ; Set stack pointer to the top of the bootloader segment
    sti                         ; Enable interrupts

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

    jmp load_PM

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

load_PM:
    cli                         ; Disable interrupts
    lgdt [gdt_descriptor]       ; Loading GDT
    mov eax, cr0
    or eax, 0x00000001          ; Set the PE bit in cr0
    ;mov cr0, eax                ; Switching to PM

    jmp PModeMain               ; Jump to protected mode entry point
    

; GDT Implementation
gdt_start:
    dd 0x00000000               ; First 2 bytes of GDT must be null (null descriptor)
    dd 0x00000000               ; First 2 bytes of GDT must be null (null descriptor)

    ; Code Segment Descriptor (8 bytes)
    dw 0xFFFF                   ; Limit (size of the segment - 1)
    dw 0x0000                   ; Base (low 16 bits)
    db 0x00                     ; Base (next 8 bits)
    db 10011010b                ; Access byte (present, ring 0, executable, readable)
    db 11001111b                ; Flags (limit granularity, size, 32-bit code)
    db 0x00                     ; Base (high 8 bits)

    ; Data Segment Descriptor (8 bytes)
    dw 0xFFFF                   ; Limit (size of the segment - 1)
    dw 0x0000                   ; Base (low 16 bits)
    db 0x00                     ; Base (next 8 bits)
    db 10010010b                ; Access byte (present, ring 0, writable)
    db 11001111b                ; Flags (limit granularity, size, 32-bit data)
    db 0x00                     ; Base (high 8 bits)

gdt_end:


gdt_descriptor:
    dw gdt_end - gdt_start - 1   ; Size of GDT - 1
    dd gdt_start

; Main PM
PModeMain:
    ;[BITS 32]
    mov ax, DATA_OFFSET
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov ss, ax
    mov gs, ax
    mov ebp, 0x9C00
    mov esp, ebp

    in al, 0x92
    or al, 2
    out 0x92, al

    jmp KERNEL_LOAD_SEG:0x0000


protected_mode_msg db "Protected Mode", 0

disk_error_msg db "Error Reading the USB Stick...", 0

times 510-($-$$) db 0          ; Fill up the remaining bytes with 0
dw 0xAA55                      ; Boot sector signature bytes
