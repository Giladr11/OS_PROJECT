# GENERAL_DIRS:
BUILD_DIR = build
SRC_DIR = src
BOOT_DIR = boot
MBR_DIR = mbr
STAGE2_DIR = stage2
KERNEL_DIR = kernel
OBJ_DIR = obj
INCLUDE_DIR = include

# Compilers:
## Boot
NASM_CMD = nasm
NASM_FLAGS = -f bin
## Kernel
I686_GCC = i686-elf-gcc
I686_LD = i686-elf-ld
CXX_FLAGS = -g -ffreestanding -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc

# SRC Files:
# Boot Source File
PRINT16_SRC = $(SRC_DIR)/$(BOOT_DIR)/print16.asm
##BOOTSEC
BOOTSEC_SRC = $(SRC_DIR)/$(BOOT_DIR)/$(MBR_DIR)/bootsec.asm
##STAGE2
LOADER_SRC = $(SRC_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/loader.asm
###INCLUDE
CRC32_SRC = $(SRC_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/$(INCLUDE_DIR)/crc32.asm
GDT_SRC = $(SRC_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/$(INCLUDE_DIR)/gdt.asm
A20_SRC = $(SRC_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/$(INCLUDE_DIR)/a20.asm
INITPM_SRC = $(SRC_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/$(INCLUDE_DIR)/initpm.asm
## Kernel Source Files:
KERNEL_ASM_SRC = $(SRC_DIR)/$(KERNEL_DIR)/kernel.asm
SCRIPT_LINKER = $(SRC_DIR)/$(KERNEL_DIR)/linker.ld
MAINKERNEL_C_SRC = $(SRC_DIR)/$(KERNEL_DIR)/KernelMain.c
###INCLUDE:
KERNEL_H = $(SRC_DIR)/$(KERNEL_DIR)/$(INCLUDE_DIR)/kernel.h

# Disk Image Commands:
SECTOR_SIZE = 512 	#bytes
STAGE2_SEEK = 1		#starts at sector 2
CONV = notrunc		#wont truncate the files
COUNT = 1

# BUILD Files:
# Boot Build Files 
##BOOTSEC
BOOTSEC_BIN = $(BUILD_DIR)/$(BOOT_DIR)/$(MBR_DIR)/bootsec.bin
##STAGE2
LOADER_BIN = $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/loader.bin
CRC32_OBJ = $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/crc32.o
CRC32_EXE = $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/crc32.exe
## Kernel OBJ Files
MAINKERNEL_C_OBJ = $(BUILD_DIR)/$(KERNEL_DIR)/$(OBJ_DIR)/kernel.o
KERNEL_ASM_OBJ = $(BUILD_DIR)/$(KERNEL_DIR)/$(OBJ_DIR)/kernel.asm.o
LINKED_KERNEL_OBJ = $(BUILD_DIR)/$(KERNEL_DIR)/$(OBJ_DIR)/linkedKernel.o
KERNEL_BIN = $(BUILD_DIR)/$(KERNEL_DIR)/kernel.bin
## Final Disk Image
DISK_IMG = $(BUILD_DIR)/disk.img

# Clean Build Directory:
RM_CMD = rm -f
CLEAN_BUILD1 = *.bin
CLEAN_BUILD2 = *.img
CLEAN_BUILD3 = *.o

# Build disk.img
all: $(DISK_IMG)

# Compile disk image
$(DISK_IMG): $(BOOTSEC_BIN) $(LOADER_BIN) $(KERNEL_BIN)
	@echo "Building $(DISK_IMG)..."
	dd if=$(BOOTSEC_BIN) of=$(DISK_IMG) bs=$(SECTOR_SIZE) count=$(COUNT) conv=$(CONV)

	$(eval LOADER_SIZE := $(shell stat -c%s $(LOADER_BIN)))
	$(eval LOADER_COUNT := $(shell echo $$((($(LOADER_SIZE) + $(SECTOR_SIZE) - 1) / $(SECTOR_SIZE)))))
	
	dd if=$(LOADER_BIN) of=$(DISK_IMG) bs=$(SECTOR_SIZE) count=$(LOADER_COUNT) seek=$(STAGE2_SEEK) conv=$(CONV)

	$(eval KERNEL_SEEK := $(shell echo $$(((`stat -c%s $(LOADER_BIN)` + $(SECTOR_SIZE) - 1) / $(SECTOR_SIZE) + 1))))
	$(eval KERNEL_SIZE := $(shell stat -c%s $(KERNEL_BIN)))
	$(eval KERNEL_COUNT := $(shell echo $$((($(KERNEL_SIZE) + $(SECTOR_SIZE) - 1) / $(SECTOR_SIZE)))))
	
	dd if=$(KERNEL_BIN) of=$(DISK_IMG) bs=$(SECTOR_SIZE) count=$(KERNEL_COUNT) seek=$(KERNEL_SEEK) conv=$(CONV)

# Compile bootsec
$(BOOTSEC_BIN): $(BOOTSEC_SRC) $(PRINT16_SRC)
	@echo "Compiling $(BOOTSEC_BIN)..."
	$(NASM_CMD) $(NASM_FLAGS) $(BOOTSEC_SRC) -o $(BOOTSEC_BIN)

# Compile stage2
$(LOADER_BIN): $(LOADER_SRC) $(GDT_SRC) $(A20_SRC) $(INITPM_SRC) $(CRC32_EXE) $(PRINT16_SRC)
	@echo "Compiling $(LOADER_BIN)..."
	$(NASM_CMD) $(NASM_FLAGS) $(LOADER_SRC) -o $(LOADER_BIN)

# Compiling crc32.exe
$(CRC32_EXE): $(CRC32_OBJ)
	ld -m elf_i386 -o $(CRC32_EXE) $(CRC32_OBJ)

# Compiling crc32.o
$(CRC32_OBJ): $(CRC32_SRC)
	$(NASM_CMD) -f elf32 $(CRC32_SRC) -o $(CRC32_OBJ)

# Compiling Final kernel.bin
$(KERNEL_BIN): $(SCRIPT_LINKER) $(LINKED_KERNEL_OBJ)
	@echo "Compiling $(KERNEL_BIN)..."
	$(I686_GCC) $(CXX_FLAGS) -T $(SCRIPT_LINKER) -o $(KERNEL_BIN) -ffreestanding -O0 -nostdlib $(LINKED_KERNEL_OBJ)

# Compiling linkedKernel.o 
$(LINKED_KERNEL_OBJ): $(KERNEL_ASM_OBJ) $(MAINKERNEL_C_OBJ)
	@echo "Compiling $(LINKED_KERNEL_OBJ)..."
	$(I686_LD) -g -relocatable $(KERNEL_ASM_OBJ) $(MAINKERNEL_C_OBJ) -o $(LINKED_KERNEL_OBJ)

# Compiling kernel.asm.o
$(KERNEL_ASM_OBJ): $(KERNEL_ASM_SRC)
	@echo "Compiling $(KERNEL_ASM_OBJ)..."
	$(NASM_CMD) -f elf $(KERNEL_ASM_SRC) -o $(KERNEL_ASM_OBJ)

# Compiling kernel.o
$(MAINKERNEL_C_OBJ): $(MAINKERNEL_C_SRC) $(KERNEL_H)
	@echo "Compiling $(MAINKERNEL_C_OBJ)..."
	$(I686_GCC) -I./src/kernel/include $(CXX_FLAGS) -std=gnu99 -c $(MAINKERNEL_C_SRC) -o $(MAINKERNEL_C_OBJ)

# Clean Build Directory
clean:
	@echo "Cleaning '$(BUILD_DIR)' Directory..."
	$(RM_CMD) $(BUILD_DIR)/$(BOOT_DIR)/$(MBR_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(BOOT_DIR)/$(MBR_DIR)/$(CLEAN_BUILD2) $(BUILD_DIR)/$(BOOT_DIR)/$(MBR_DIR)/$(CLEAN_BUILD3)
	$(RM_CMD) $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/$(CLEAN_BUILD2) $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/$(CLEAN_BUILD3) $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/*.exe
	$(RM_CMD) $(BUILD_DIR)/$(KERNEL_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(KERNEL_DIR)/$(CLEAN_BUILD2) $(BUILD_DIR)/$(KERNEL_DIR)/$(CLEAN_BUILD3)
	$(RM_CMD) $(BUILD_DIR)/$(KERNEL_DIR)/$(OBJ_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(KERNEL_DIR)/$(OBJ_DIR)/$(CLEAN_BUILD2) $(BUILD_DIR)/$(KERNEL_DIR)/$(OBJ_DIR)/$(CLEAN_BUILD3)
	$(RM_CMD) $(BUILD_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(CLEAN_BUILD2)
