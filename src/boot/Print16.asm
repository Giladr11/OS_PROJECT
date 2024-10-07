;Print (16-bit) Real-Mode

%ifndef PRINT16_ASM
%define PRINT16_ASM

PRINT:
    mov ah, 0x0E

.PRINTCHAR:
    lodsb
    cmp al, 0
    je .DONE
    int 0x10
    jmp .PRINTCHAR

.DONE:
    ret

%endif
