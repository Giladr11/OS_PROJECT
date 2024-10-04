# 🖥️ **OS_PROJECT**

## Overview
This project focuses on the development of a **32-bit operating system** from scratch. It implements a two-stage bootloader and a kernel, transitioning from real mode to protected mode. The system is built using **low-level assembly** and **C/C++** to demonstrate complete control over the hardware.

## ⚙️ Key Features
- 🔑 **32-bit Protected Mode**: Leverages advanced CPU features for memory protection and task management.
- 🔄 **Checksum Verification**: Ensures kernel integrity before execution.
- ⚡ **Segment and GDT Setup**: Properly configures memory segments and the Global Descriptor Table.
- 🚀 **Multi-stage Bootloader**: Efficient two-stage bootloader to initialize the system.

---

## 🛠️ **PART 1: Two-Stage Bootloader Implementation**

### **Stage 1**
- 🛡️ **Segment Setup**: Initializes segment registers for memory management in real mode.
- 📥 **Load Stage 2**: Loads the second stage of the bootloader into memory.
- 🚀 **Control Transfer**: Jumps to Stage 2 for further system initialization.

### **Stage 2**
- 🛡️ **Segment Setup**: Reinitializes segment registers for consistency.
- 📥 **Kernel Loading**: Loads the kernel into RAM for execution.
- ✅ **Checksum Validation**: Verifies the kernel’s integrity through a checksum process.
- 🛠️ **GDT Setup**: Initializes the Global Descriptor Table (GDT) for protected mode.
- 🔐 **Protected Mode Switch**: Transitions the CPU to protected mode, enabling advanced memory and security features.
- 🚀 **Kernel Execution**: Transfers control to the kernel to begin core operating system functions.

---

## 🖥️ **PART 2: Kernel Implementation**

The kernel serves as the brain of the operating system, handling all system-level tasks, including hardware communication and CPU management.

### **Key Kernel Functions**
- 🧠 **Memory Management**: Efficient allocation and deallocation of system memory.
- 🔄 **Task Scheduling**: Manages multitasking and ensures efficient CPU usage.
- 🛡️ **Interrupt Handling**: Processes hardware and software interrupts to maintain system stability.

---

## 💻 **How to Run the Project**

### Prerequisites
- Install [QEMU](https://www.qemu.org/) (or any x86 emulator) for running the OS.
- Install **NASM** (for assembling bootloader code) and **GCC** (for compiling C/C++ kernel code).

### Instructions
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Giladr11/OS_PROJECT.git
   cd OS_PROJECT

2. **Set Execution Permissions (only required once)**:
    ```bash
    chmod +x build.sh

3.  **Build and Run**:
    ```bash
    ./build.sh
    qemu-system-x86_64 -drive format=raw,file=build/disk.img

## 🛠️ **Project Structure**
The project follows a structured folder architecture for better organization:

OS_PROJECT/
├── build/
│   ├── boot/
│   │   ├── stage1/
│   │   └── stage2/
│   └── kernel/
│       └── obj/
├── src/
│   ├── boot/
│   │   ├── stage1/
│   │   └── stage2/
│   └── kernel/
│       └── include/
├── build.sh
├── Makefile
├── .gitignore
└── README.md

### **build/: Contains compiled outputs for the bootloader and kernel**:

- *boot/stage1/: Output files for the first stage of the bootloader.*
- *boot/stage2/: Output files for the second stage of the bootloader.*
- *kernel/obj/: Object files generated during the kernel compilation.*

### **src/: Contains the source code for the bootloader and kernel**:

- *boot/stage1/: Source files for the first stage of the bootloader.*
- *boot/stage2/: Source files for the second stage of the bootloader.*
- *kernel/include/: Header files for the kernel.*

- *build.sh: A script to automate the build and execution process.*
- *Makefile: Used for compiling the project.*
- *.gitignore: Specifies files and directories that should be ignored by Git.*
- *README.md: Documentation for the project.*

**By following the steps above, you can easily build and run your custom 32-bit operating system on QEMU or any compatible emulator.**