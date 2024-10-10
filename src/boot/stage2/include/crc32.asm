section .data
    polynomial db 0xED, 0xB8, 0x83, 0x20    ; CRC32 polynomial: 0xEDB88320
    message db 'HELLO', 0                   ; Example string
    message_len equ $-message               ; Length of message
    hex_digits db '0123456789ABCDEF'        ; Digits for converting to hexadecimal
    newline db 0xA, 0                       ; Newline character

section .bss
    crc_res resd 1                          ; Space for storing the result
    hex_string resb 33                       ; Space for 8 hex digits + null terminator

section .text
    global _start

_start:
    ; Initialize the CRC value to 0xFFFFFFFF
    mov eax, 0xFFFFFFFF
    mov [crc_res], eax

    ; Prepare registers
    mov esi, message         ; esi -> pointer to message
    mov ecx, message_len     ; ecx -> length of message

crc32_loop:
    ; If no more bytes, exit the loop
    test ecx, ecx
    jz crc32_done

    ; Load the next byte of the message
    movzx eax, byte [esi]    ; Load byte into eax and zero extend it

    ; XOR the byte with the current CRC value
    mov edx, [crc_res]       ; Load the current CRC value
    xor edx, eax             ; XOR the byte into the CRC value
    mov [crc_res], edx       ; Store updated CRC value back

    ; Process the byte, bit-by-bit
    mov ebx, 8               ; Each byte is 8 bits

crc32_bitwise:
    test edx, 1              ; Check the least significant bit (LSB)
    jz crc32_no_polynomial   ; If LSB is 0, no need to XOR with the polynomial
    ; XOR with the polynomial 0xEDB88320
    xor edx, 0xEDB88320

crc32_no_polynomial:
    shr edx, 1               ; Shift right by 1 bit (process next bit)
    dec ebx                  ; Decrease bit count
    jnz crc32_bitwise        ; Repeat for all bits in the byte

    ; Move to the next byte of the message
    inc esi
    dec ecx                  ; Decrease the byte counter
    jmp crc32_loop           ; Process the next byte

crc32_done:
    ; Finalize the CRC value: XOR with 0xFFFFFFFF
    mov eax, [crc_res]       ; Load the current CRC value
    xor eax, 0xFFFFFFFF      ; Final XOR step
    mov [crc_res], eax       ; Store final CRC value

    ; Convert the CRC result to a hexadecimal string
    mov edi, hex_string + 8  ; Point to the end of the string (null terminator)
    mov byte [edi], 0        ; Null-terminate the string
    mov eax, [crc_res]       ; Load the final CRC result

print_hex_loop:
    dec edi                  ; Move the pointer left
    mov edx, eax             ; Copy CRC value into edx
    and edx, 0xF             ; Mask out the lowest 4 bits (one hex digit)
    mov dl, [hex_digits + edx] ; Get the corresponding hex character
    mov [edi], dl            ; Store the hex digit in the string
    shr eax, 4               ; Shift right by 4 bits to process the next hex digit
    test eax, eax            ; Check if all digits are processed
    jnz print_hex_loop       ; Repeat for all digits

    ; Print the result
    mov eax, 4               ; System call number for sys_write
    mov ebx, 1               ; File descriptor 1 (stdout)
    mov ecx, hex_string      ; Pointer to the string to print
    mov edx, 8 * 4           ; Length of the string (8 hex digits * 4 bytes per digit)
    int 0x80                 ; Call the kernel

    ; Print a newline
    mov eax, 4               ; System call number for sys_write
    mov ebx, 1               ; File descriptor 1 (stdout)
    mov ecx, newline         ; Pointer to newline character
    mov edx, 1               ; Length of the newline character
    int 0x80                 ; Call the kernel

    ; Exit the program
    mov eax, 1               ; System call number for exit
    xor ebx, ebx             ; Exit status 0
    int 0x80                 ; Call the kernel