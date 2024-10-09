;CRC32 Algorithem implementation
section .data
    ; CRC32 Lookup Table
    crc32_table db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    ; Initialize the CRC value
    initial_crc dd 0xffffffff

section .text
global crc32
; Compute CRC32 for a given data buffer
; Parameters:
;   edi - pointer to the data buffer
;   ecx - length of the buffer
; Return:
;   eax - CRC32 checksum
crc32:
    ; Load initial CRC value
    mov eax, initial_crc

crc_loop:
    ; Check if we have processed all bytes
    test ecx, ecx
    jz done

    ; Load the next byte from the buffer
    movzx ebx, byte [edi]
    inc edi              ; Move to the next byte

    ; Update the CRC value
    xor eax, ebx
    shr eax, 8          ; Shift the CRC value right
    xor eax, [crc32_table + eax] ; XOR with lookup table value

    ; Decrement the byte counter
    dec ecx
    jmp crc_loop        ; Repeat for the next byte

done:
    ; Finalize CRC value
    not eax
    ret
