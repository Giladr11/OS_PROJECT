;Main Stage2
[ORG 0x4000]
[BITS 16]

KERNEL_LOAD_SEG equ 0x1000

_start: 
    mov ax, 0x4000
    mov ds, ax
    xor ax, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x3FFF

    call load_kernel
    jmp load_PM

load_kernel:
    mov si, load_kernel_message
    call print

    mov ah, 0x02                    ; Read Sectors
    mov dl, 0x80                    ; Drive number
    mov dh, 0x00                    ; Head number
    mov ch, 0x00                    ; Cylinder number
    mov cl, 0x03                    ; Sector number
    mov al, 0x14                    ; Number of sectors to read
    mov bx, KERNEL_LOAD_SEG         ; Set Memory address to load Kernel
    mov es, bx                      ; Set Extra segment to the load address
    int 0x13                        ; BIOS interrupt to read from disk
    jc disk_error                   
    ret

disk_error:
    mov si, disk_error_message
    call print             
    hlt                          

load_kernel_message db "Loading Kernel to RAM..."  , 0x0D, 0x0A, 0
disk_error_message  db "Error Reading Disk..."     , 0x0D, 0x0A, 0

%include "src/boot/stage2/include/INITPM.asm"
%include "src/boot/Print16.asm"

times 512-($-$$) db 0
