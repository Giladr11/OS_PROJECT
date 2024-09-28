# GENERAL_DIRS
BUILD_DIR = build
SRC_DIR = src
BOOT_DIR = boot
KERNEL_DIR = kernel
INCLUDE_DIR = include

# Compilers
# Boot
NASM_CMD = nasm
NASM_FLAGS = -f bin
# Kernel
CXX = g++
CXX_FLAGS = -m32 -ffreestanding -c

# SRC Files
# Boot Source File
BOOT_SOURCE = boot.asm
GDT_SOURCE = $(SRC_DIR)/$(BOOT_DIR)/$(INCLUDE_DIR)/GDT.asm
INITPM_SOURCE = $(SRC_DIR)/$(BOOT_DIR)/$(INCLUDE_DIR)/INITPM.asm
# Kernel Source Files
KERNEL_SRC = kernel.asm

# Disk Image Commands
BOOT_SIZE = 512 	#bytes
SEEK = 1			#starts at sector 2
CONV = notrunc
COUNT = 1

# Linking
LINKER = ld -T
LINKER_FILE = linker.ld
LINKER_FLAGS = -m elf_i386

# BUILD Files
# Boot Build Files 
BOOT_BIN = boot.bin
# Kernel Build Files
KERNEL_OBJ = kernel.o
KERNEL_BIN = kernel.bin
# Final Disk Image
DISK_IMG = disk.img

# Clean Build Directory
RM_CMD = rm -f
CLEAN_BUILD1 = *.bin
CLEAN_BUILD2 = *.img
CLEAN_BUILD3 = *.o

# Build disk.img
all: $(BUILD_DIR)/$(DISK_IMG)

# Compile disk image
$(BUILD_DIR)/$(DISK_IMG): $(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_BIN) $(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_BIN)
	@echo "Building $(BUILD_DIR)/$(DISK_IMG)..."
	dd if=$(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_BIN) of=$(BUILD_DIR)/$(DISK_IMG) bs=$(BOOT_SIZE) count=$(COUNT) conv=$(CONV)

	$(eval KERNEL_SIZE := $(shell stat -c%s $(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_BIN)))
	dd if=$(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_BIN) of=$(BUILD_DIR)/$(DISK_IMG) bs=$(KERNEL_SIZE) count=$(COUNT) seek=$(SEEK) conv=$(CONV)

# Compile to boot.bin
$(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_BIN): $(SRC_DIR)/$(BOOT_DIR)/$(BOOT_SOURCE) $(INITPM_SOURCE) $(GDT_SOURCE)
	@echo "Building $(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_BIN)..."
	$(NASM_CMD) $(NASM_FLAGS) $(SRC_DIR)/$(BOOT_DIR)/$(BOOT_SOURCE) -o $(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_BIN)

$(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_BIN): $(SRC_DIR)/$(KERNEL_DIR)/$(KERNEL_SRC)
	@echo "Building $(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_BIN)..."
	$(NASM_CMD) $(NASM_FLAGS) $(SRC_DIR)/$(KERNEL_DIR)/$(KERNEL_SRC) -o $(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_BIN)


# # Compile kernel.o
# $(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_OBJ): $(SRC_DIR)/$(KERNEL_DIR)/$(KERNEL_SRC) $(SRC_DIR)/$(KERNEL_DIR)/$(LINKER_FILE)
# 	@echo "Building $(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_OBJ)..."
# 	$(CXX) $(CXX_FLAGS) $(SRC_DIR)/$(KERNEL_DIR)/$(KERNEL_SRC) -o $(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_OBJ)

# Compile kernel cpp files into obj files and store them into build dir
# $(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_BIN): $(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_OBJ) $(SRC_DIR)/$(KERNEL_DIR)/$(LINKER_FILE)
# 	@echo "Linking $(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_BIN)..."
# 	$(LINKER) $(SRC_DIR)/$(KERNEL_DIR)/$(LINKER_FILE) $(LINKER_FLAGS) -o $(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_BIN) $(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_OBJ)


# Clean Build Directory
clean:
	@echo "Cleaning $(BUILD_DIR) Directory..."
	$(RM_CMD) $(BUILD_DIR)/$(BOOT_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(BOOT_DIR)/$(CLEAN_BUILD2) $(BUILD_DIR)/$(BOOT_DIR)/$(CLEAN_BUILD3)
	$(RM_CMD) $(BUILD_DIR)/$(KERNEL_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(KERNEL_DIR)/$(CLEAN_BUILD2) $(BUILD_DIR)/$(KERNEL_DIR)/$(CLEAN_BUILD3)
	$(RM_CMD) $(BUILD_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(CLEAN_BUILD2)
