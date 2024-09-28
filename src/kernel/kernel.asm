[ORG 0x1000]                ; Kernel loads at address 0x1000
[BITS 32]                   ; Switch to 32-bit mode

section .text
global start

start:
    ; Set up the segment registers
    mov eax, 0x1000         ; Set data segment to where the kernel is loaded
    mov ds, ax              ; Set DS to point to the data segment
    mov es, ax              ; Set ES to point to the extra segment
    mov fs, ax              ; Set FS to point to the FS segment
    mov gs, ax              ; Set GS to point to the GS segment
    ; The stack should be set properly in the bootloader; we can use an arbitrary stack location here
    mov ebp, 0x9000         ; Base pointer for the stack
    mov esp, ebp            ; Set stack pointer

    jmp print               ; Jump to print function

print:
    mov esi, kernel_success  ; Load address of the string into ESI
    mov edx, 0x0E            ; BIOS teletype function

.read_char:
    lodsb                    ; Load byte at DS:ESI into AL and increment ESI
    cmp al, 0               ; Check for null terminator
    je .done                ; If zero, jump to done
    mov ebx, 0x00000000     ; Prepare to print character using BIOS interrupt
    int 0x10                ; Call BIOS interrupt to print character in AL
    jmp .read_char          ; Repeat for next character

.done:
    hlt                     ; Halt CPU

kernel_success db "Kernel is Running!!", 0  ; Null-terminated string

; Fill remaining space with zeros to reach 512 bytes
times (512 - ($ - $$)) db 0  
