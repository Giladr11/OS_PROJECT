; GDT Implementation
NULL_DESC:
    dd 0                    ; Null descriptor (4 bytes)
    dd 0                    ; Null descriptor (4 bytes)
CODE_DESC:
    dw 0xFFFF               ; Limit of the code segment
    dw 0x0000               ; Base address (first 16 bits)
    db 0x00                 ; Base address (next 8 bits)
    db 10011010b            ; Access byte
    db 11001111b            ; Granularity
    db 0x00                 ; Base address (last 8 bits)
DATA_DESC:
    dw 0xFFFF               ; Limit of the data segment
    dw 0x0000               ; Base address (first 16 bits)
    db 0x00                 ; Base address (next 8 bits)
    db 10010010b            ; Access byte
    db 11001111b            ; Granularity
    db 0x00                 ; Base address (last 8 bits)

GDT_END:
    GDT_DESC:
        GDT_SIZE:
            dw GDT_END - NULL_DESC - 1   ; Size of GDT - 1
            dd NULL_DESC                 ; Base address of GDT

; Segment offsets
CODE_SEG equ CODE_DESC - NULL_DESC
DATA_SEG equ DATA_DESC - CODE_DESC
