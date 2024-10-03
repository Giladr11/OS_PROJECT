# OS PROJECT
Implementing a 2 stages bootloader:

Stage1:
* Setting up segments
* Loading Stage2
* Transferring Control to Stage2

Stage2:
* Setting up segments
* Loading Kernel to RAM
* Conducting CHECKSUM for Kernel
* Setting up GDT
* Switching to PM
* Transferring Control to Kernel