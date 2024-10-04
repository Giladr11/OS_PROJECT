# OS_PROJECT

## Overview
This project involves implementing a two-stage bootloader and a basic kernel from scratch. The goal is to understand low-level operating system concepts, including memory management and switching to protected mode.

## PART 1: Implementing a Two-Stage Bootloader

### Stage 1:
- **Setting Up Segments**: Initialize segment registers for code and data segments.
- **Loading Stage 2**: Load the second stage of the bootloader into memory.
- **Transferring Control**: Jump to Stage 2 for further execution.

### Stage 2:
- **Setting Up Segments**: Prepare the segment registers for protected mode.
- **Loading Kernel to RAM**: Load the kernel into memory for execution.
- **Conducting CHECKSUM on the Kernel**: Verify the integrity of the kernel.
- **Setting Up GDT**: Initialize the Global Descriptor Table.
- **Switching to Protected Mode**: Transition the CPU to protected mode for advanced memory management.
- **Transferring Control to Kernel**: Jump to the kernel's entry point to begin execution.

## PART 2: Implementing The Kernel
- Details about kernel implementation will be provided here.
