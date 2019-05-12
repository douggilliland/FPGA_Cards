#!/bin/sh
#
# This file was automatically generated by the Nios II IDE Flash Programmer.
#
# It will be overwritten when the flash programmer options change.
#

cd E:/E22_BGA_SDRAM_test/software/E22_BGA_SDRAM_test/Debug

# Creating .flash file for the FPGA configuration
"$SOPC_KIT_NIOS2/bin/sof2flash" --epcs --input="E:/E22_BGA_SDRAM_test/NIOS_SDRAM.sof" --output="NIOS_SDRAM.flash" 

# Programming flash with the FPGA configuration
"$SOPC_KIT_NIOS2/bin/nios2-flash-programmer" --epcs --base=0x04801800  "NIOS_SDRAM.flash"

# Creating .flash file for the project
"$SOPC_KIT_NIOS2/bin/elf2flash" --base=0x04400000 --end=0x47fffff --reset=0x4801800 --input="E22_BGA_SDRAM_test.elf" --output="cfi_flash_0.flash" --boot="C:/altera/11.0/ip/altera/nios2_ip/altera_nios2/boot_loader_cfi.srec"

# Programming flash with the project
"$SOPC_KIT_NIOS2/bin/nios2-flash-programmer" --base=0x04400000  "cfi_flash_0.flash"

# Creating .flash file for the project
"$SOPC_KIT_NIOS2/bin/elf2flash" --epcs --after="NIOS_SDRAM.flash" --input="E22_BGA_SDRAM_test.elf" --output="epcs_flash_controller_0.flash"

# Programming flash with the project
"$SOPC_KIT_NIOS2/bin/nios2-flash-programmer" --epcs --base=0x04801800  "epcs_flash_controller_0.flash"

