	DEFW DPLUS, "D+"
	# ( UD1_LO UD1_HI UD1_LO UD1_HI -- UD3_LO UD3_HI )
	lw x14, 0(x9) # UD2 LO32
	lw x13, 4(x9) # UD1 HI32
	lw x12, 8(x9) # UD1 LO32
	addi x9, x9, 8
	add x12, x12, x14
	sltu x14, x12, x14
	add x15, x15, x13
	add x15, x15, x14
	sw x12, 0(x9)
	ret
	ENDW DPLUS

	DEFW DMINUS, "D-"
	# ( UD1_LO UD1_HI UD2_LO UD2_HI -- UD3_LO UD3_HI )
	lw x14, 0(x9) # UD2 LO32
	lw x13, 4(x9) # UD1 HI32
	lw x12, 8(x9) # UD1 LO32
	addi x9, x9, 8
	sltu x11, x12, x14
	sub x12, x12, x14
	sub x15, x13, x15
	sub x15, x15, x11
	sw x12, 0(x9)
	ret
	ENDW DMINUS