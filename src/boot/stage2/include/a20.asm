;Enabling A20 line
[BITS 16]

initA20:
    in al, 0x92
    or al, 0x02
    out 0x92, al

    in al, 0x92
    test al, 0x02
    jz A20_failed

    call A20_success
    ret

A20_success:    
    mov si, success_messsage
    call print
    ret

A20_failed:
    mov si, error_messsage
    call print
    hlt

success_messsage db "Successfully Enabled A20!" , 0x0D, 0x0A, 0
error_messsage  db "Failed to Enable A20!"      , 0x0D, 0x0A, 0

%include "src/boot/print16.asm"
