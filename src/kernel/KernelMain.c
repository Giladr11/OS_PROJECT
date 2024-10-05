#include "include/kernel.h"

// Define the VGA text buffer address
#define VGA_BUFFER_ADDRESS 0xB8000

// Define colors
#define WHITE_ON_BLACK 0x0F

// Function to print a string to the VGA text buffer
void print_string(const char* str) {
    // Pointer to the VGA buffer
    char* vga_buffer = (char*)VGA_BUFFER_ADDRESS;
    
    // Write the string to the VGA buffer
    while (*str) {
        // Each character is 2 bytes: character and attribute
        *vga_buffer++ = *str++;  // Character
        *vga_buffer++ = WHITE_ON_BLACK;  // Attribute (white on black)
    }
}

// Kernel main function
void kernel_main() {
    print_string("kernel is running");
    
    // Hang the kernel (prevent it from exiting)
    while (1) {
        __asm__ __volatile__("hlt"); // Halt the CPU
    }
}
