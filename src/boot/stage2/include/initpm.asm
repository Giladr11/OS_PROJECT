;Protected Mode Initialization
[BITS 16]

KERNEL_START_ADDR equ 0x100000

load_pm:    
    call initA20

    call print_pm_msg

<<<<<<< HEAD
    call print_kernel_exe_msg

=======
>>>>>>> 1a7b0b0d65515aef5518f50f6043b4ce9b6f6ee2
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
    mov si, protected_mode_message
    call print
    ret

print_kernel_exe_msg:
    mov si, kernel_execution_message
    call print
    ret

<<<<<<< HEAD

protected_mode_message   db "[+] Transitioning into Protected Mode..." , 0x0D, 0x0A, 0x0D, 0x0A, 0
kernel_execution_message db "[+] Initiating Kernel Execution..."       , 0x0D, 0x0A, 0x0D, 0x0A, 0
=======
PM_message db "Transitioning into Protected Mode and Executing the kernel..." , 0x0D, 0x0A, 0x0D, 0x0A, 0
>>>>>>> 1a7b0b0d65515aef5518f50f6043b4ce9b6f6ee2


%include "src/boot/stage2/include/gdt.asm"
%include "src/boot/stage2/include/a20.asm"
%include "src/boot/print16.asm"
