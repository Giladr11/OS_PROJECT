# GENERAL_DIRS:
BUILD_DIR = build
SRC_DIR = src
BOOT_DIR = boot
STAGE1_DIR = stage1
STAGE2_DIR = stage2
KERNEL_DIR = kernel
INCLUDE_DIR = include
OBJ_DIR = obj

# Compilers:
# Boot
NASM_CMD = nasm
NASM_FLAGS = -f bin
# Kernel
CXX = g++
CXX_FLAGS = -m32 -ffreestanding -c

# SRC Files:
# Boot Source File
#STAGE1
BOOT_SOURCE = $(SRC_DIR)/$(BOOT_DIR)/$(STAGE1_DIR)/boot.asm
#STAGE2
LOADER_SOURCE = $(SRC_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/loader.asm
GDT_SOURCE = $(SRC_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/GDT.asm
# Kernel Source Files:
KERNEL_SRC = $(SRC_DIR)/$(KERNEL_DIR)/kernel.asm
#Include

# Disk Image Commands:
SECTOR_SIZE = 512 	#bytes
STAGE2_SEEK = 1		#starts at sector 2
CONV = notrunc
COUNT = 1

# Linking:
LINKER = ld -T
LINKER_FILE = linker.ld
LINKER_FLAGS = -m elf_i386

# BUILD Files:
# Boot Build Files 
#STAGE1
BOOT_BIN = $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE1_DIR)/boot.bin
#STAGE2
LOADER_BIN = $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/loader.bin
# Kernel Build Files
KERNEL_OBJ = $(BUILD_DIR)/$(KERNEL_DIR)/$(OBJ_DIR)/kernel.o
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
$(DISK_IMG): $(KERNEL_BIN) $(BOOT_BIN) $(LOADER_BIN)
	@echo "Building $(DISK_IMG)..."
	dd if=$(BOOT_BIN) of=$(DISK_IMG) bs=$(SECTOR_SIZE) count=$(COUNT) conv=$(CONV)

	$(eval STAGE2_SIZE := $(shell stat -c%s $(LOADER_BIN)))
	dd if=$(LOADER_BIN) of=$(DISK_IMG) bs=$(STAGE2_SIZE) count=$(COUNT) seek=$(STAGE2_SEEK) conv=$(CONV)

	$(eval KERNEL_SEEK := $(shell echo $$(((`stat -c%s $(LOADER_BIN)` + $(SECTOR_SIZE) - 1) / $(SECTOR_SIZE) + 1))))
	$(eval KERNEL_SIZE := $(shell stat -c%s $(KERNEL_BIN)))
	dd if=$(KERNEL_BIN) of=$(DISK_IMG) bs=$(KERNEL_SIZE) count=$(COUNT) seek=$(KERNEL_SEEK) conv=$(CONV)

# Compile stage1
$(BOOT_BIN): $(BOOT_SOURCE)
	@echo "Building $(BOOT_BIN)..."
	$(NASM_CMD) $(NASM_FLAGS) $(BOOT_SOURCE) -o $(BOOT_BIN)

# Compile stage2
$(LOADER_BIN): $(LOADER_SOURCE) $(GDT_SOURCE)
	@echo "Building $(LOADER_BIN)..."
	$(NASM_CMD) $(NASM_FLAGS) $(LOADER_SOURCE) -o $(LOADER_BIN)

# Compile kernel
$(KERNEL_BIN): $(KERNEL_SRC)
	@echo "Building $(KERNEL_BIN)..."
	$(NASM_CMD) $(NASM_FLAGS) $(KERNEL_SRC) -o $(KERNEL_BIN)


# # Compile kernel.o
# $(KERNEL_OBJ): $(KERNEL_SRC) $(LINKER_FILE)
# 	@echo "Building $(KERNEL_OBJ)..."
# 	$(CXX) $(CXX_FLAGS) $(KERNEL_SRC) -o $(KERNEL_OBJ)

# Compile kernel cpp files into obj files and store them into build dir
# $(KERNEL_BIN): $(KERNEL_OBJ) $(LINKER_FILE)
# 	@echo "Linking $(KERNEL_BIN)..."
# 	$(LINKER) $(LINKER_FILE) $(LINKER_FLAGS) -o $(KERNEL_BIN) $(KERNEL_OBJ)


# Clean Build Directory
clean:
	@echo "Cleaning '$(BUILD_DIR)' Directory..."
	$(RM_CMD) $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE1_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE1_DIR)/$(CLEAN_BUILD2) $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE1_DIR)/$(CLEAN_BUILD3)
	$(RM_CMD) $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/$(CLEAN_BUILD2) $(BUILD_DIR)/$(BOOT_DIR)/$(STAGE2_DIR)/$(CLEAN_BUILD3)
	$(RM_CMD) $(BUILD_DIR)/$(KERNEL_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(KERNEL_DIR)/$(CLEAN_BUILD2) $(BUILD_DIR)/$(KERNEL_DIR)/$(CLEAN_BUILD3)
	$(RM_CMD) $(BUILD_DIR)/$(KERNEL_DIR)/$(OBJ_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(KERNEL_DIR)/$(OBJ_DIR)/$(CLEAN_BUILD2) $(BUILD_DIR)/$(KERNEL_DIR)/$(OBJ_DIR)/$(CLEAN_BUILD3)
	$(RM_CMD) $(BUILD_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(CLEAN_BUILD2)
