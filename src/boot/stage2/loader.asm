;Main loader
[ORG 0x8000]
[BITS 16]

section .data
    KERNEL_LOAD_SEG equ 0x1000

section .text
    global _start

_start: 
    mov ax, 0x8000
    mov ds, ax
    mov ss, ax
    mov es, ax

    mov sp, 0x7FFF 

    call print_press_key

    call wait_for_key

    call read_kernel
    
    call print_start_checksum_message

    call calc_kernel_checksum

    call compare_checksums
    
    call load_kernel

    jmp load_pm

wait_for_key:
    mov ah, 0x00
    int 0x16

    cmp ah, 0x1C
    jne wait_for_key

    ret

read_kernel:
    call print_readkernel_msg
    
    mov ah, 0x02                    
    mov dl, 0x80                    
    mov dh, 0x00                    
    mov ch, 0x00                    
    mov cl, 0x07                    
    mov al, 0x0C                   
                                 
    mov bx, read_kernel_buffer                             

    int 0x13                        
    
    jc print_disk_error             
    ret

load_kernel:
    call print_loadkernel_msg
    
    mov ah, 0x02                    
    mov dl, 0x80                    
    mov dh, 0x00                    
    mov ch, 0x00                    
    mov cl, 0x07                    
    mov al, 0x0C                   
    
    mov bx,  KERNEL_LOAD_SEG
    mov es, bx                            

    int 0x13                        
    
    jc print_disk_error             
    ret

print_press_key:
    mov si, press_load_kernel
    call print
    ret

print_start_checksum_message:
    mov si, checksum_start_msg
    call print
    ret

print_readkernel_msg:
    mov si, read_kernel_message
    call print
    ret

print_loadkernel_msg:
    mov si, load_kernel_message
    call print
    ret

print_disk_error:
    mov si, disk_error_message
    call print             

    jmp $                        


press_load_kernel   db "Press 'Enter' to Advance System Initialization..."       , 0x0D, 0x0A, 0x0D, 0x0A, 0
read_kernel_message db "[+] Accessing Kernel on disk for integrity check..."     , 0x0D, 0x0A, 0x0D, 0x0A, 0
load_kernel_message db "[+] Loading Kernel to RAM..."                            , 0x0D, 0x0A, 0x0D, 0x0A, 0
checksum_start_msg  db "[+] Initiating Kernel CRC-32 Checksums Verification..."  , 0x0D, 0x0A, 0x0D, 0x0A, 0
disk_error_message  db "[-] Error: Reading Disk!"                                , 0x0D, 0x0A, 0x0D, 0x0A, 0


%include "src/boot/stage2/include/crc32_verifier.asm"
%include "src/boot/stage2/include/initpm.asm"
%include "src/boot/print16.asm"

times 1536-($-$$) db 0x0
