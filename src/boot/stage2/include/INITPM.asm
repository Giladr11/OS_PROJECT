;Initializing Protected Mode
[BITS 16]

KERNEL_START_ADDR equ 0x100000

load_PM:
    mov si, PM_message
    call print

    cli
    
    lgdt [GDT_DESC]
    
    call INITA20

    mov eax, cr0
    or eax, 0x1                 
    mov cr0, eax                

    mov eax, cr0
    test eax, 0x1
    jz ERROR_PM

    jmp CODE_SEG:PModeMain       

[BITS 32]     
PModeMain:
    mov ax, DATA_SEG                
    mov ds, ax                      
    mov es, ax                      
    mov ss, ax                      
    mov fs, ax                      
    mov gs, ax                      

    mov ebp, 0x9C00
    mov esp, ebp
    
    jmp CODE_SEG:KERNEL_START_ADDR

ERROR_PM:
    mov si, ERROR_PM_message
    call print
    hlt

PM_message db "Initializing Protected Mode.." , 0x0D, 0x0A, 0
ERROR_PM_message db "Error Switching to Protected Mode...", 0x0D, 0x0A, 0


%include "src/boot/stage2/include/GDT.asm"
%include "src/boot/stage2/include/A20.asm"
%include "src/boot/Print16.asm"
