# 🖥️ OS_PROJECT

## Overview
This project is focused on building a two-stage bootloader and a kernel entirely from scratch, with the ultimate goal of developing a fully functional **32-bit Operating System**. The system is built to transition seamlessly from real mode to protected mode, leveraging low-level assembly and C/C++.

## ⚙️ Key Features
- 🔑 **32-bit Protected Mode** 
- 🔄 **Checksum Verification** for kernel integrity
- ⚡ **Segment and GDT Setup**
- 🚀 **Multi-stage Bootloader**

---

## 🛠️ PART 1: Implementing a Two-Stage Bootloader

### Stage 1
- 🛡️ **Setting Up Segments**: Initialize segment registers to ensure proper memory management.
- 📥 **Loading Stage 2**: Read the second stage of the bootloader into memory.
- 🚀 **Transferring Control**: Jump to the entry point of Stage 2 for further execution.


### Stage 2
- 🛡️ **Setting Up Segments**: Initialize segment registers again to maintain proper memory management.
- 📥 **Loading Kernel to RAM**: Load the kernel into memory for execution.
- ✅ **Conducting CHECKSUM on the Kernel**: Verify the integrity of the kernel to ensure it hasn't been tampered with.
- 🛠️ **Setting Up GDT**: Initialize the Global Descriptor Table for memory management in protected mode.
- 🔐 **Switching to Protected Mode**: Transition the CPU to protected mode for advanced memory features.
- 🚀 **Transferring Control to Kernel**: Jump to the kernel's entry point to begin the OS's main operations.

![Bootloader Stage 2 Diagram](https://via.placeholder.com/600x200) <!-- Replace with actual image -->

---

## 🖥️ PART 2: Implementing the Kernel
The kernel is the core part of this operating system. Its main roles include managing CPU instructions, handling hardware communication, and performing system-level tasks.

### Key Responsibilities:
- 🧠 **Memory Management**: Efficient allocation and deallocation of memory.
- 🔄 **Task Scheduling**: Handles multitasking and CPU process management.
- 🛡️ **Interrupt Handling**: Responds to hardware and software interrupts.

---

## 💻 How to Run the Project

### Prerequisites
- Install [QEMU](https://www.qemu.org/) or any x86 emulator.
- Ensure you have **NASM** (for assembly) and **GCC** (for C compilation) installed.

### Steps to Run
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Giladr11/OS_PROJECT.git
   
   cd OS_PROJECT

   chmod +x build.sh (only if you didnt set execute premmision yet)

   ./build.sh

   qemu-system-x86_64 -drive format=raw,file=build/disk.img
