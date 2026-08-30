	DEFW FIFO8_NEW, "FIFO8-NEW"
	# ( SIZE -- FIFO8-ADDR )
	# MCU ONLY HAVE 20KiB SRAM, SO USE 16BIT SIZE/HEAD/TAIL
	# .2BYTE SIZE
	# .2BYTE HEAD
	# .2BYTE TAIL
	# .FILL SIZE, 1, 0
	mv x14, x15
	la x13, FORTH_DP
	lw x15, 0(x13)
	addi x15, x15, 1
	andi x15, x15, -2
	addi x12, x15, (2 + 2 + 2)
	add x12, x12, x14
	addi x12, x12, 1
	sw x12, 0(x13)
	addi x14, x14, 1
	sh x14, 0(x15)
	sh x0, 2(x15)
	sh x0, 4(x15)
	ret
	ENDW FIFO8_NEW

	DEFW FIFO8_RESET, "FIFO8-RESET"
	# ( FIFO8-ADDR -- )
	sh x0, 2(x15)
	sh x0, 4(x15)
	PPOP x15
	ret
	ENDW FIFO8_RESET

	DEFW FIFO8_IS_EMPTY, "FIFO8-EMPTY?"
	# ( FIFO8-ADDR -- FLAG )
	lhu x14, 2(x15)
	lhu x13, 4(x15)
	li x15, 0
	bne x14, x13, 1f
	li x15, -1
1:
	ret
	ENDW FIFO8_IS_EMPTY

	DEFW FIFO8_IS_FULL, "FIFO8-FULL?"
	# ( FIFO8-ADDR -- FLAG )
	lhu x14, 0(x15)
	lhu x13, 2(x15)
	lhu x12, 4(x15)
	addi x12, x12, 1
	remu x12, x12, x14
	li x15, 0
	bne x12, x13, 1f
	li x15, -1
1:
	ret
	ENDW FIFO8_IS_FULL

	DEFW FIFO8_NUM_USED, "FIFO8-NUM-USED"
	# ( FIFO8-ADDR -- COUNT )
	lhu x14, 0(x15)
	lhu x13, 2(x15)
	lhu x12, 4(x15)
	sub x15, x12, x13
	add x15, x15, x14
	remu x15, x15, x14
	ret
	ENDW FIFO8_NUM_USED

	DEFW FIFO8_NUM_FREE, "FIFO8-NUM-FREE"
	# ( FIFO8-ADDR -- COUNT )
	lhu x14, 0(x15)
	lhu x13, 2(x15)
	lhu x12, 4(x15)
	sub x15, x12, x13
	add x15, x15, x14
	remu x15, x15, x14
	addi x14, x14, -1
	sub x15, x14, x15
	ret
	ENDW FIFO8_NUM_FREE

	DEFW FIFO8_PUSH, "FIFO8-PUSH"
	# ( C FIFO8-ADDR -- )
	mv x14, x15
	lw x13, 0(x9)
	lw x15, 4(x9)
	addi x9, x9, 8
	lhu x12, 4(x14)
	add x11, x14, x12
	sb x13, 6(x11)
	fence rw, rw
	addi x12, x12, 1
	lhu x11, 0(x14)
	remu x12, x12, x11
	sh x12, 4(x14)
	ret
	ENDW FIFO8_PUSH
	
	DEFW FIFO8_POP, "FIFO8-POP"
	# ( FIFO8-ADDR -- C )
	mv x14, x15
	lhu x13, 2(x14)
	add x12, x14, x13
	lbu x15, 6(x12)
	fence rw, rw
	addi x13, x13, 1
	lhu x12, 0(x14)
	remu x13, x13, x12
	sh x13, 2(x14)
	ret
	ENDW FIFO8_POP
