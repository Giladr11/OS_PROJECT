# OS_PROJECT

## PART 1:
### Implementing a 2 stages bootloader:

Stage1:
* Setting up segments
* Loading Stage2
* Transferring Control to Stage2

Stage2:
* Setting up segments
* Loading Kernel to RAM
* Conducting CHECKSUM on the Kernel
* Setting up GDT
* Switching to PM
* Transferring Control to Kernel

## PART2:
### Implemeting The Kernel
