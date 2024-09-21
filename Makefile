#GENERAL_DIRS:
BUILD_DIR = build
SRC_DIR = src
BOOT_DIR = boot
KERNEL_DIR = kernel

#Compilers:
#Boot
NASM_CMD = nasm
BOOT_FLAGS = -f bin
TRUNCATE_CMD = truncate -s 1440k
#Kernel
CXX = g++
CXX_FLAGS = -m32 -ffreestanding -Wall -Wextra
CXX_LINKER = -T linker.ld -o

#BUILD Files:
#Boot Build Files 
BOOT_IMG = boot.img
BOOT_BIN = boot.bin
#Kernel Build Files
KERNEL_BIN = kernel.bin
# KERNEL_OBJS = $(KERNE_SRCS:.cpp=.o)
#Final OS Image:
OS_IMG = os.img

#SRC Files:
#Boot Source File
BOOT_SOURCE = boot.asm
#Kernel Source Files
# KERNEL_SRCS = 

# CLEANING BUILD_DIR:
CP_CMD = cp
RM_CMD = rm -f
CLEAN_BUILD1 = *.bin
CLEAN_BUILD2 = *.img

#Build OS
# all: $(OS_IMG)

#Build OS image by linking the boot.bin and the kernel.bin


#Compile to boot.img 
$(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_IMG): $(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_BIN)
	@echo "Building $(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_IMG)..."
	$(CP_CMD) $(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_BIN) $(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_IMG)
	$(TRUNCATE_CMD) $(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_IMG)

#Compile to boot.bin
$(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_BIN): $(SRC_DIR)/$(BOOT_DIR)/$(BOOT_SOURCE)
	@echo "Building $(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_BIN)..."
	$(NASM_CMD) $(BOOT_FLAGS) $(SRC_DIR)/$(BOOT_DIR)/$(BOOT_SOURCE) -o $(BUILD_DIR)/$(BOOT_DIR)/$(BOOT_BIN)

#Linking Kernel.obj files into one kernel.bin file


#Compile kernel cpp files into obj files and store them into build dir


#Clean Build Directory
clean:
	@echo "Cleaning $(BUILD_DIR) Dir..."
	$(RM_CMD) $(BUILD_DIR)/$(BOOT_DIR)/$(CLEAN_BUILD1) $(BUILD_DIR)/$(BOOT_DIR)/$(CLEAN_BUILD2)
	#need to add clean kernel.obj files and kernel.bin