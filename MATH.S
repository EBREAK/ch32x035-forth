	DEFW XPLUS, "X+"
	# ( UX1_LO UX1_HI UX1_LO UX1_HI -- UX3_LO UX3_HI )
	lw x14, 0(x9) # UX2 LO32
	lw x13, 4(x9) # UX1 HI32
	lw x12, 8(x9) # UX1 LO32
	addi x9, x9, 8
	add x12, x12, x14
	sltu x14, x12, x14
	add x15, x15, x13
	add x15, x15, x14
	sw x12, 0(x9)
	ret
	ENDW XPLUS

	DEFW XMINUS, "X-"
	# ( UX1_LO UX1_HI UX2_LO UX2_HI -- UX3_LO UX3_HI )
	lw x14, 0(x9) # UX2 LO32
	lw x13, 4(x9) # UX1 HI32
	lw x12, 8(x9) # UX1 LO32
	addi x9, x9, 8
	sltu x11, x12, x14
	sub x12, x12, x14
	sub x15, x13, x15
	sub x15, x15, x11
	sw x12, 0(x9)
	ret
	ENDW XMINUS

	DEFW XMULTI, "X*"
	# ( X1_LO X1_HI X2_LO X2_HI -- X3_LO X3_HI )
	lw x14, 0(x9) # X2 LO32
	lw x13, 4(x9) # X1 HI32
	lw x12, 8(x9) # X1 LO32
	addi x9, x9, 8
	mul x11, x15, x12 # X2_HI * X1_LO
	mul x13, x13, x14 # X1_HI * X2_LO
	mulhu x15, x12, x14 # HI32(X1_LO * X2_LO)
	add x15, x15, x11
	add x15, x15, x13
	mul x12, x12, x14 # X3 LO32
	sw x12, 0(x9)
	ret
	ENDW XMULTI

	DEFW UXDIVID, "UX/"
	# ( UX1_LO UX1_HI UX2_LO UX2_HI -- UX3_LO UX3_HI )
	lw x13, 4(x9)
	lw x12, 8(x9)
	addi x8, x8, -12
	sw x15, 4(x8)
	lw x15, 0(x9)
	sw x15, 0(x8)
	addi x9, x9, 8
	li x14, 0
	li x15, 0
	li x10, 64
	sw x10, 8(x8)
UXLOOP:
	srli x10, x13, 31
	srli x11, x12, 31
	slli x13, x13, 1
	or x13, x13, x11
	slli x12, x12, 1
	srli x11, x14, 31
	slli x15, x15, 1
	or x15, x15, x11
	slli x14, x14, 1
	or x14, x14, x10
	lw x10, 0(x8)
	lw x11, 4(x8)
	bne x15, x11, UXCMP
	bltu x14, x10, UXSKIP
	j UXSUB
UXCMP:
	bltu x15, x11, UXSKIP
UXSUB:
	sub x15, x15, x11
	sltu x11, x14, x10
	sub x14, x14, x10
	sub x15, x15, x11
	ori x12, x12, 1
UXSKIP:
	lw x10, 8(x8)
	addi x10, x10, -1
	sw x10, 8(x8)
	bnez x10, UXLOOP
	addi x8, x8, 12
	sw x12, 0(x9)
	mv x15, x13
	ret
	ENDW UXDIVID