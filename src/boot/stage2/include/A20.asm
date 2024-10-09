;Enabling A20 line
[BITS 16]

INITA20:
    in al, 0x92
    or al, 0x02
    out 0x92, al

    in al, 0x92
    test al, 0x02
    jz A20_FAILED

    call A20_SUCCESS
    ret

A20_SUCCESS:    
    mov si, success_messsage
    call PRINT
    ret

A20_FAILED:
    mov si, error_messsage
    call PRINT
    hlt

success_messsage db "Successfully Enabled A20!" , 0x0D, 0x0A, 0
error_messsage  db "Failed to Enable A20!"      , 0x0D, 0x0A, 0

%include "src/boot/Print16.asm"
