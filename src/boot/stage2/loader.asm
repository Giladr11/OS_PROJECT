;Main loader
[ORG 0x8000]
[BITS 16]

KERNEL_LOAD_SEG equ 0x1000

_START: 
    mov ax, 0x8000
    mov ds, ax
    mov ss, ax
    mov es, ax

    mov sp, 0x0600  

    call LOAD_KERNEL
    jmp LOAD_PM

LOAD_KERNEL:
    call LOAD_KERNEL_MESSAGE

    mov ah, 0x02                    ; Read Sectors
    mov dl, 0x80                    ; Drive number
    mov dh, 0x00                    ; Head number
    mov ch, 0x00                    ; Cylinder number
    mov cl, 0x03                    ; Sector number
    mov al, 0x14                    ; Number of sectors to read
    mov bx, KERNEL_LOAD_SEG         ; Set Memory address to load Kernel
    mov es, bx                      ; Set Extra segment to the load address
    int 0x13                        ; BIOS interrupt to read from disk
    jc DISK_ERROR                   
    ret

LOAD_KERNEL_MESSAGE:
    mov si, load_kernel_message
    call PRINT
    ret

DISK_ERROR:
    mov si, disk_error_message
    call PRINT             
    hlt                          

load_kernel_message db "Loading Kernel to RAM..."  , 0x0D, 0x0A, 0
disk_error_message  db "Error Reading Disk..."     , 0x0D, 0x0A, 0

%include "src/boot/stage2/include/initpm.asm"
%include "src/boot/print16.asm"

times 512-($-$$) db 0
