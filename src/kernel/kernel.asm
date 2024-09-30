[ORG 0x2000]                     ; Kernel starts at 0x1000
[BITS 16]                        ; Use 16-bit real mode

start:
    mov ax, 0x2000               ; Set data segment to 0x7E00 where the kernel is loaded
    mov ds, ax                   ; Initialize DS to point to the kernel
    mov es, ax
    mov ss, ax
    mov bp, 0x20F0
    mov sp, bp                   ; Set stack pointer to the top of the kernel
    mov si, kernel_success       ; Load the address of the success message into SI
    jmp print                    ; Jump to the print function

print:
    mov ah, 0x0E                ; BIOS teletype output function
.read_char:
    lodsb                       ; Load byte at DS:SI into AL and increment SI
    cmp al, 0                   ; Check for null terminator
    je .done                    ; If null terminator, go to done
    int 0x10                    ; Print character in AL
    jmp .read_char              ; Repeat for the next character
.done:
    hlt                         ; Halt the CPU

kernel_success db "Kernel is Running!!", 0  ; Null-terminated string

times 512 - ($ - $$) db 0    ; Fill remaining space with 0
