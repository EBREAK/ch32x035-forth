CROSS_COMPILE ?= riscv32-qingke-elf-
CC = $(CROSS_COMPILE)gcc
OD = $(CROSS_COMPILE)objdump
OC = $(CROSS_COMPILE)objcopy
SZ = $(CROSS_COMPILE)size

CFLAGS += \
	-march=rv32imac_zicsr_zifencei -mabi=ilp32 \
	-nostdlib -nostartfiles -static -ggdb \
	-T Link.ld \

fw:
	$(CC) $(CFLAGS) FORTH.S -o fw.elf
	$(OD) -D fw.elf > fw.dis
	$(OC) -O ihex fw.elf fw.hex
	$(OC) -O binary fw.elf fw.bin
	$(SZ) fw.elf

clean:
	rm -vf *.elf *.bin *.out *.dis *.map *.hex *.o

flash:
	wlink set-power disable3v3
	sleep 0.5
	wlink set-power enable3v3
	wlink flash fw.hex
	wlink set-power disable3v3
	sleep 0.5
	wlink set-power enable3v3
	wlink resume
