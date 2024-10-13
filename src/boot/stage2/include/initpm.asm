;Initializing Protected Mode
[BITS 16]

KERNEL_START_ADDR equ 0x100000

load_pm:
    call print_pm_msg
    
    call initA20

    lgdt [GDT_DESC]

    mov eax, cr0
    or eax, 0x01                 
    ;mov cr0, eax                

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

[BITS 16]
print_pm_msg:
    mov si, PM_message
    call print
    ret


PM_message db "Transitioning into Protected Mode..." , 0x0D, 0x0A, 0x0D, 0x0A, 0


%include "src/boot/stage2/include/gdt.asm"
%include "src/boot/stage2/include/a20.asm"
%include "src/boot/print16.asm"
