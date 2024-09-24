#GENERAL_DIRS:
BUILD_DIR = build
SRC_DIR = src
BOOT_DIR = boot
KERNEL_DIR = kernel

#Compilers:
#Boot
NASM_CMD = nasm
NASM_FLAGS = -f bin
#Kernel
CXX = g++
CXX_FLAGS = -m32 -ffreestanding -Wall -Wextra
CXX_LINKER = -T linker.ld -o

#SRC Files:
#Boot Source File
BOOT_SOURCE = boot.asm
#Kernel Source Files
# KERNEL_SRCS = 

#Disk Image Commands:
DISK_SIZE = 512
SEEK = 1
CONV = notrunc
COUNT = 1

#BUILD Files:
#Boot Build Files 
BOOT_BIN = boot.bin
#Kernel Build Files
KERNEL_BIN = kernel.bin
# KERNEL_OBJS = $(KERNE_SRCS:.cpp=.o)
#Final OS Image:
DISK_IMG = disk.img

# CLEANING BUILD_DIR:
CP_CMD = cp
RM_CMD = rm -f
CLEAN_BUILD1 = *.bin
CLEAN_BUILD2 = *.img


#Build disk.img
all: $(BUILD_DIR)/$(DISK_IMG)

#Build OS image by linking the boot.bin and the kernel.bin
$(BUILD_DIR)/$(DISK_IMG): $(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_BIN) $(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_BIN)
	@echo "Building $(BUILD_DIR)/$(DISK_IMG)..."
	dd if=$(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_BIN) of=$(BUILD_DIR)/$(DISK_IMG) bs=$(DISK_SIZE) count=$(COUNT) conv=$(CONV)
	dd if=$(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_BIN) of=$(BUILD_DIR)/$(DISK_IMG) bs=$(DISK_SIZE) count=$(COUNT) seek=$(SEEK) conv=$(CONV)

#Compile to boot.bin
$(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_BIN): $(SRC_DIR)/$(BOOT_DIR)/$(BOOT_SOURCE)
	@echo "Building $(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_BIN)..."
	$(NASM_CMD) $(NASM_FLAGS) $(SRC_DIR)/$(BOOT_DIR)/$(BOOT_SOURCE) -o $(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_BIN)

#Linking Kernel.obj files into one kernel.bin file


#Compile kernel cpp files into obj files and store them into build dir
$(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_BIN): $(SRC_DIR)/$(KERNEL_DIR)/kernel.asm
	@echo "Building $(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_BIN)..."
	$(NASM_CMD) $(NASM_FLAGS) $(SRC_DIR)/$(KERNEL_DIR)/kernel.asm -o $(BUILD_DIR)/$(KERNEL_DIR)/$(KERNEL_BIN)

#Clean Build Directory
clean:
	@echo "Cleaning $(BUILD_DIR) Dir..."
	$(RM_CMD) $(BUILD_DIR)/$(BOOT_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(BOOT_DIR)/$(CLEAN_BUILD2)
	#need to add clean kernel.obj files and kernel.bin
	$(RM_CMD) $(BUILD_DIR)/$(KERNEL_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(KERNEL_DIR)/$(CLEAN_BUILD2)
	$(RM_CMD) $(BUILD_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(CLEAN_BUILD2)