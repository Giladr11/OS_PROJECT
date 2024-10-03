[ORG 0x2000]
[BITS 16]

CODE_SEG equ 0x08
DATA_SEG equ 0x10
KERNEL_LOAD_SEG equ 0x1000
KERNEL_START_ADDR equ 0x100000

_start: 
    mov ax, 0x2000
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x1FFE    

    call load_kernel
    jmp load_PM

;Load kernel to RAM
load_kernel:
    mov si, load_kernel_message
    call print

    mov ah, 0x02                    ; Function: Read Sectors
    mov dl, 0x80                    ; Reading from Hard Disk
    mov dh, 0x00                    ; Head number (0)
    mov ch, 0x00                    ; Cylinder number (0)
    mov cl, 0x03                    ; Sector number (3)
    mov al, 0x14                    ; Number of sectors to read (20)
    mov bx, KERNEL_LOAD_SEG         ; Load kernel at memory address 0x1000
    mov es, bx                      ; Set ES to the load address
    int 0x13                        ; BIOS interrupt to read from disk
    jc disk_error                   ; Jump to error handling if carry flag is set
    ret

;Initializing Protected Mode
load_PM:
    mov si, switch_pm_message
    call print

    cli
    lgdt [GDT_DESC]
    
    mov eax, cr0
    or eax, 0x1                 
    mov cr0, eax                

    jmp CODE_SEG:PModeMain       


;START OF GDT implementation
GDT_START:
    dd 0x0
    dd 0x0

    dw 0xFFFF                       ; Limit (lower 16 bits) = 0xFFFF (64 KB)
    dw 0x0000                       ; Base (lower 16 bits) = 0 (starting from 0) 
    db 0x00                         ; Base (middle 8 bits) = 0
    db 10011010b                    ; Access byte: (present, executable, readable, privilege level 0)
    db 11001111b                    ; Granularity: (limit is in 4 KB pages, 32-bit segment)
    db 0x00                         ; Base (upper 8 bits) = 0

    dw 0xFFFF                       ; Limit (lower 16 bits) = 0xFFFF (64 KB)
    dw 0x0000                       ; Base (lower 16 bits) = 0 (starting from 0) 
    db 0x00                         ; Base (middle 8 bits) = 0
    db 10010010b                    ; Access byte: (present, writable, readable, privilege level 0)
    db 11001111b                    ; Granularity: (limit is in 4 KB pages, 32-bit segment)
    db 0x00                         ; Base (upper 8 bits) = 0
GDT_END:

GDT_DESC:
    dw GDT_END - GDT_START - 1      ; Size of GDT -1
    dd GDT_START 

;Initialize A20 to Allow Access Above 1MB 
[BITS 32]
INITA20:
    in al, 0x92                     ; Read the A20 line state
    or al, 0x02                     ; Set A20 line bit
    out 0x92, al                    ; Write back to port 0x92
    ret

;Set up segments for protected mode
[BITS 32]     
PModeMain:
    mov ax, DATA_SEG                ; Load data segment selector
    mov ds, ax                      ; Set DS to data segment
    mov es, ax                      ; Set ES to data segment
    mov ss, ax                      ; Set SS to data segment
    mov fs, ax                      ; Set FS to data segment
    mov gs, ax                      ; Set GS to data segment

    mov ebp, 0x9C00
    mov esp, ebp

    call CODE_SEG:INITA20
    
    jmp CODE_SEG:KERNEL_START_ADDR

disk_error:
    mov si, disk_error_message
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

load_kernel_message db "Loading Kernel to RAM..."    , 0x0D, 0x0A, 0
switch_pm_message db "Initializing Protected Mode.."   , 0x0D, 0x0A, 0
disk_error_message db "Error Reading Disk..."        , 0x0D, 0x0A, 0

times 512-($-$$) db 0
