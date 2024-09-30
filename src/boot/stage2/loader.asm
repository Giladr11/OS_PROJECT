[ORG 0x8C00]
[BITS 16]

;%include "src/boot/stage2/GDT.asm"

KERNEL_LOAD_SEG equ 0x2000
KERNEL_ENTRY_OFFSET equ 0x0000

_start:
    mov ax, 0x8C00               ; Set data segment to 0x7D00 where the kernel is loaded
    mov ds, ax                   ; Initialize DS to point to stage2
    mov es, ax
    mov ss, ax
    mov bp, 0x8CF0
    mov sp, bp                  ; Set stack pointer to the top of the bootloader
    call load_kernel
    call ENTER_PM
    jmp KERNEL_LOAD_SEG:KERNEL_ENTRY_OFFSET

load_kernel:
    mov ah, 0x02                ; Function: Read Sectors
    mov dl, 0x80                ; Drive number
    mov dh, 0x00                ; Head number
    mov ch, 0x00                ; Cylinder number (0)
    mov cl, 0x03                ; Sector number (3)
    mov al, 0x01                ; Number of sectors to read (1)
    mov bx, KERNEL_LOAD_SEG     ; Load kernel at memory address 0x1000
    mov es, bx                  ; Set ES to the load address
    int 0x13                    ; BIOS interrupt to read from disk
    jc disk_error               ; Jump to error handling if carry flag is set
    ret

;Entry point for initializing protected mode
ENTER_PM:
    call INITA20                ; Initialize A20 line
    cli                         ; Disable interrupts
    ;lgdt [GDT_DESC]             ; Load the Global Descriptor Table

    mov eax, cr0                ; Read control register 0
    xor eax , eax
    or eax, 0x1                 ; Set PE bit to enable protected mode
    ;mov cr0, eax                ; Write back to control register 0

    sti                         ; Enable interrupts
    jmp PM_START      ; Far jump to set CS and start in protected mode

; Procedure to initialize A20 line
INITA20:
    in al, 0x92                 ; Read the A20 line state
    or al, 2                    ; Set A20 line bit
    out 0x92, al                ; Write back to port 0x92
    ret

; Set up segments for protected mode
;[BITS 32]                       ; Switch to 32-bit mode
PM_START:
    mov ax, 0;DATA_DESC           ; Load data segment selector
    mov ds, ax                  ; Set DS to data segment
    mov es, ax                  ; Set ES to data segment
    mov ss, ax                  ; Set SS to data segment
    mov fs, ax                  ; Set FS to data segment
    mov gs, ax                  ; Set GS to data segment
    
    ;mov eax, cr0
    ;test eax, 0x1
    ;jz PM_ERROR
    jmp KERNEL_LOAD_SEG:KERNEL_ENTRY_OFFSET

disk_error:
    mov si, disk_error_message
    call print16             
    hlt                          

PM_ERROR:
    mov si, pm_error_message
    call print16
    hlt

;Print 16 BITS
print16:
    mov ah, 0x0E
.printchar16:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .printchar16
.done:
    ret

pm_error_message db "Error Switching to PM...", 0
disk_error_message db "Error Reading the USB Stick...", 0

times 512 - ($-$$) db 0