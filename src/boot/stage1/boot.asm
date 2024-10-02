[ORG 0x7C00]
[BITS 16]

CODE_SEG equ 0x8
DATA_SEG equ 0x10

KERNEL_LOAD_SEG equ 0x1000
KERNEL_START_ADDR equ 0x100000

_start:
    cli
    mov ax, 0x00                ; Set segments to 0x8C00 where the stage2 is loaded
    mov ds, ax                   
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00      
    sti
    
    call load_kernel
    jmp load_PM
    
load_kernel:
    mov ah, 0x02                ; Function: Read Sectors
    mov dl, 0x80                ; Drive number
    mov dh, 0x00                ; Head number
    mov ch, 0x00                ; Cylinder number (0)
    mov cl, 0x02                ; Sector number (2)
    mov al, 0x14                ; Number of sectors to read (1)
    mov bx, KERNEL_LOAD_SEG     ; Load kernel at memory address 0x1000
    mov es, bx                  ; Set ES to the load address
    int 0x13                    ; BIOS interrupt to read from disk
    jc disk_error               ; Jump to error handling if carry flag is set
    ret

;Entry point for initializing protected mode
load_PM:
    cli
    lgdt [GDT_DESC]

    mov eax, cr0
    or eax, 0x1                 ; Set PE bit to enable protected mode
    mov cr0, eax                ; Write back to control register 0

    jmp CODE_SEG:PModeMain       ; Far jump to set CS and start in protected mode


;GDT implementation
GDT_START:
    dd 0x0
    dd 0x0

    ; Code segment descriptor
    dw 0xFFFF                  ; Limit (lower 16 bits) = 0xFFFF (64 KB)
    dw 0x0000                  ; Base (lower 16 bits) = 0 (starting from 0) 
    db 0x00                    ; Base (middle 8 bits) = 0
    db 10011010b               ; Access byte: (present, executable, readable, privilege level 0)
    db 11001111b               ; Granularity: (limit is in 4 KB pages, 32-bit segment)
    db 0x00                    ; Base (upper 8 bits) = 0

    ; Data segment descriptor
    dw 0xFFFF                  ; Limit (lower 16 bits) = 0xFFFF (64 KB)
    dw 0x0000                  ; Base (lower 16 bits) = 0 (starting from 0) 
    db 0x00                    ; Base (middle 8 bits) = 0
    db 10010010b               ; Access byte: (present, writable, readable, privilege level 0)
    db 11001111b               ; Granularity: (limit is in 4 KB pages, 32-bit segment)
    db 0x00                    ; Base (upper 8 bits) = 0
GDT_END:

GDT_DESC:
    dw GDT_END - GDT_START - 1 ; Size of GDT -1
    dd GDT_START 


;Set up segments for protected mode
[BITS 32]     
PModeMain:
    mov ax, DATA_SEG            ; Load data segment selector
    mov ds, ax                  ; Set DS to data segment
    mov es, ax                  ; Set ES to data segment
    mov ss, ax                  ; Set SS to data segment
    mov fs, ax                  ; Set FS to data segment
    mov gs, ax                  ; Set GS to data segment
    mov ebp, 0x9C00
    mov esp, ebp
    
    in al, 0x92                 ; Read the A20 line state
    or al, 2                    ; Set A20 line bit
    out 0x92, al                ; Write back to port 0x92
    
    jmp CODE_SEG:KERNEL_START_ADDR

disk_error:
    mov si, disk_error_message
    call print             
    hlt                          

PM_ERROR:
    mov si, pm_error_message
    call print
    hlt

print:
    mov ah, 0x0E
.printchar:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .printchar
.done:
    ret

pm_error_message db "Error Switching to PM", 0
disk_error_message db "Error Reading the USB Stick...", 0

times 510-($-$$) db 0

dw 0xAA55