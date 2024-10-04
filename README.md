# OS_PROJECT

## Overview
This project involves implementing a two-stage bootloader and a kernel from scratch, Aiming to Develop a Fully Functional Operating System. 

## PART 1: Implementing a Two-Stage Bootloader

### Stage 1:
- **Setting Up Segments**: Initialize segment registers for proper memory management

- **Loading Stage 2**: Load the second stage of the bootloader into memory.

- **Transferring Control**: Jump to Stage 2 for further execution.

### Stage 2:
- **Setting Up Segments**: Initialize segment registers for proper memory management

- **Loading Kernel to RAM**: Load the kernel into memory for execution.

- **Conducting CHECKSUM on the Kernel**: Verify the integrity of the kernel.

- **Setting Up GDT**: Initialize the Global Descriptor Table.

- **Switching to Protected Mode**: Transition the CPU to protected mode for advanced memory management.

- **Transferring Control to Kernel**: Jump to the kernel's entry point to begin execution.

## PART 2: Implementing The Kernel

