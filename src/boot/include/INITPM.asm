; Protected Mode Initialization
[BITS 16]

KERNEL_LOAD_SEG equ 0x1000
KERNEL_ENTRY_OFFSET equ 0x0000

jmp ENTER_PM

%include "src/boot/include/GDT.asm"

ENTER_PM:
    call INITA20                 ;Initialize A20 line
    cli                          ;Disable interrupts
    lgdt [GDT_DESC]              ;Load the Global Descriptor Table
    mov eax, cr0                 ;Read control register 0
    or eax, 1                    ;Set PE bit to enable protected mode
    mov cr0, eax                 ;Write back to control register 0
    jmp CODE_SEG:PM_START        ;Far jump to set CS and start in protected mode

; Access memory above 1 MB in PM
INITA20:
    in al, 0x92                  ;Read the A20 line state
    or al, 2                     ;Set A20 line bit
    out 0x92, al                 ;Write back to port 0x92
    ret

; Set up segments for PM
[BITS 32]                      
PM_START:
    mov ax, DATA_SEG             ;Load data segment selector
    mov es, ax                   ;Set ES to data segment
    mov ds, ax                   ;Set DS to data segment
    mov ss, ax                   ;Set SS to data segment
    mov fs, ax                   ;Set FS to data segment
    mov gs, ax                   ;Set GS to data segment 
    
    jmp KERNEL_LOAD_SEG:KERNEL_ENTRY_OFFSET
