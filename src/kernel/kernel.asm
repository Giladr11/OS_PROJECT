[BITS 32]                        

global _START

extern kernel_main

_START:
    call kernel_main
    jmp $

times 512 - ($ - $$) db 0        ; Fill remaining sector space with 0
