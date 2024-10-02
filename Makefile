# GENERAL_DIRS:
BUILD_DIR = build
SRC_DIR = src
BOOT_DIR = boot
STAGE1_DIR = stage1
STAGE2_DIR = stage2
KERNEL_DIR = kernel
OBJ_DIR = obj

# Compilers:
# Boot
NASM_CMD = nasm
NASM_FLAGS = -f bin
# Kernel
I686_GCC = i686-elf-gcc
I686_LD = i686-elf-ld
CXX_FLAGS = -g -ffreestanding -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc

# SRC Files:
# Boot Source File
#STAGE1
BOOT_SRC = $(SRC_DIR)/$(BOOT_DIR)/$(STAGE1_DIR)/boot.asm
#STAGE2
LOADER_SRC = $(SRC_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/loader.asm
# Kernel Source Files:
KERNEL_ASM_SRC = $(SRC_DIR)/$(KERNEL_DIR)/kernel.asm
KERNEL_C_SRC = $(SRC_DIR)/$(KERNEL_DIR)/kernel.c
SCRIPT_LINKER = $(SRC_DIR)/$(KERNEL_DIR)/linker.ld

# Disk Image Commands:
SECTOR_SIZE = 512 	#bytes
STAGE2_SEEK = 1		#starts at sector 2
CONV = notrunc		#wont truncate the files
COUNT = 1

# BUILD Files:
# Boot Build Files 
#STAGE1
BOOT_BIN = $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE1_DIR)/boot.bin
#STAGE2
LOADER_BIN = $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/loader.bin
# Kernel Build Files
KERNEL_C_OBJ = $(BUILD_DIR)/$(KERNEL_DIR)/$(OBJ_DIR)/kernel.o
KERNEL_ASM_OBJ = $(BUILD_DIR)/$(KERNEL_DIR)/$(OBJ_DIR)/kernel.asm.o
LINKED_KERNEL_OBJ = $(BUILD_DIR)/$(KERNEL_DIR)/$(OBJ_DIR)/linkedKernel.o
KERNEL_BIN = $(BUILD_DIR)/$(KERNEL_DIR)/kernel.bin
# Final Disk Image
DISK_IMG = $(BUILD_DIR)/disk.img

# Clean Build Directory:
RM_CMD = rm -f
CLEAN_BUILD1 = *.bin
CLEAN_BUILD2 = *.img
CLEAN_BUILD3 = *.o

# Build disk.img
all: $(DISK_IMG)

# Compile disk image
$(DISK_IMG): $(BOOT_BIN)  $(KERNEL_BIN)
	@echo "Building $(DISK_IMG)..."
	dd if=$(BOOT_BIN) of=$(DISK_IMG) bs=$(SECTOR_SIZE) count=$(COUNT) conv=$(CONV)

	

	$(eval KERNEL_SEEK := $(shell echo $$(((`stat -c%s $(BOOT_BIN)` + $(SECTOR_SIZE) - 1) / $(SECTOR_SIZE) + 1))))
	$(eval KERNEL_SIZE := $(shell stat -c%s $(KERNEL_BIN)))
	dd if=$(KERNEL_BIN) of=$(DISK_IMG) bs=$(KERNEL_SIZE) count=$(COUNT) seek=1 conv=$(CONV)

# Compile stage1
$(BOOT_BIN): $(BOOT_SRC)
	@echo "Compiling $(BOOT_BIN)..."
	$(NASM_CMD) $(NASM_FLAGS) $(BOOT_SRC) -o $(BOOT_BIN)

# Compile stage2
# $(LOADER_BIN): $(LOADER_SRC)
# 	@echo "Compiling $(LOADER_BIN)..."
# 	$(NASM_CMD) $(NASM_FLAGS) $(LOADER_SRC) -o $(LOADER_BIN)

# Compiling Final kernel.bin
$(KERNEL_BIN): $(SCRIPT_LINKER) $(LINKED_KERNEL_OBJ)
	@echo "Compiling $(KERNEL_BIN)..."
	$(I686_GCC) $(CXX_FLAGS) -T $(SCRIPT_LINKER) -o $(KERNEL_BIN) -ffreestanding -O0 -nostdlib $(LINKED_KERNEL_OBJ)

# Compiling linkedKernel.o 
$(LINKED_KERNEL_OBJ): $(KERNEL_ASM_OBJ) $(KERNEL_C_OBJ)
	@echo "Compiling $(LINKED_KERNEL_OBJ)..."
	$(I686_LD) -g -relocatable $(KERNEL_ASM_OBJ) $(KERNEL_C_OBJ) -o $(LINKED_KERNEL_OBJ)

# Compiling kernel.asm.o
$(KERNEL_ASM_OBJ): $(KERNEL_ASM_SRC)
	@echo "Compiling $(KERNEL_ASM_OBJ)..."
	$(NASM_CMD) -f elf $(KERNEL_ASM_SRC) -o $(KERNEL_ASM_OBJ)

# Compiling kernel.o
$(KERNEL_C_OBJ): $(KERNEL_C_SRC)
	@echo "Compiling $(KERNEL_C_OBJ)..."
	$(I686_GCC) -I./src/kernel/include $(CXX_FLAGS) -std=gnu99 -c $(KERNEL_C_SRC) -o $(KERNEL_C_OBJ)

# Clean Build Directory
clean:
	@echo "Cleaning '$(BUILD_DIR)' Directory..."
	$(RM_CMD) $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE1_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE1_DIR)/$(CLEAN_BUILD2) $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE1_DIR)/$(CLEAN_BUILD3)
	$(RM_CMD) $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/$(CLEAN_BUILD2) $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/$(CLEAN_BUILD3)
	$(RM_CMD) $(BUILD_DIR)/$(KERNEL_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(KERNEL_DIR)/$(CLEAN_BUILD2) $(BUILD_DIR)/$(KERNEL_DIR)/$(CLEAN_BUILD3)
	$(RM_CMD) $(BUILD_DIR)/$(KERNEL_DIR)/$(OBJ_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(KERNEL_DIR)/$(OBJ_DIR)/$(CLEAN_BUILD2) $(BUILD_DIR)/$(KERNEL_DIR)/$(OBJ_DIR)/$(CLEAN_BUILD3)
	$(RM_CMD) $(BUILD_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(CLEAN_BUILD2)
