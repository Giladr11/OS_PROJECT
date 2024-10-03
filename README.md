# OS_PROJECT
Implementing a 2 stages bootloader:

Stage1:
* Setting up segments
* Loading stage2

Stage2:
* Setting up segments
* Loading kernel to RAM
* Conducting CHECKSUM for kernel
* Setting up GDT
* Switching to PM
* Transfering Access to Kernel