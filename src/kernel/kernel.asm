[ORG 0x1000]              ; Kernel loads at address 0x1000
[BITS 16]

start:
    mov ax, 0x1000         ; Set data segment to where the kernel is loaded
    mov ds, ax
    mov es, ax             ; Set extra segment to the same
    jmp print              ; Jump to print function

print:
    mov si, kernel_success  ; Load address of the string into SI
    mov ah, 0x0E           ; BIOS teletype function

.read_char:
    lodsb                   ; Load byte at DS:SI into AL and increment SI
    cmp al, 0              ; Check for null terminator
    je .done               ; If zero, jump to done
    int 0x10              ; Call BIOS interrupt to print character in AL
    jmp .read_char        ; Repeat for next character

.done:
    hlt                    ; Halt CPU

kernel_success db "Kernel is Running!!", 0  ; Null-terminated string

times (512 - ($ - $$)) db 0  ; Fill remaining space with zeros
dw 0xAA55                   ; Boot sector signature
