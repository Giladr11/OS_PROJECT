;GDT IMPLEMENTATION
global GDT_DESC
global CODE_SEG
global DATA_SEG

section .data
    GDT_START:
        NULL_DESC:
            dw 0x0000
            dw 0x0000
            db 0x00
            db 0x00
            db 0x00
            db 0x00
    
        CODE_DESC:
            dw 0xFFFF               ; Limit of the code segment
            dw 0x0000               ; Base address (first 16 bits)
            db 0x00                 ; Base address (next 8 bits)
            db 0x9A                 ; Access byte (present, executable, readable)
            db 0xCF                 ; Granularity (4KB, 32-bit limit)
            db 0x00                 ; Base address (last 8 bits)
    
        DATA_DESC:
            dw 0xFFFF               ; Limit of the data segment
            dw 0x0000               ; Base address (first 16 bits)
            db 0x00                 ; Base address (next 8 bits)
            db 0x92                 ; Access byte (present, writable, readable)
            db 0xCF                 ; Granularity (4KB, 32-bit limit)
            db 0x00                 ; Base address (last 8 bits)
    GDT_END:
    
    GDT_DESC:
        dw GDT_END - GDT_START - 1   ; Size of GDT - 1
        dd GDT_START                 ; Base address of GDT
    
    CODE_SEG equ 0x08
    DATA_SEG equ 0x10
