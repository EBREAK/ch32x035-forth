	# GPIO NUMBER MAPPING TABLE:
	# PA   0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F 10 11 12 13 14 15 16 17 18 19 1A 1B 1C 1D 1E 1F
	# NUM  0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F 10 11 12 13 14 15 16 17 18 19 1A 1B 1C 1D 1E 1F
	# PB   0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F 10 11 12 13 14 15 16 17 18 19 1A 1B 1C 1D 1E 1F
	# NUM 20 21 22 23 24 25 26 27 28 29 2A 2B 2C 2D 2E 2F 30 31 32 33 34 35 36 37 38 39 3A 3B 3C 3D 3E 3F
	# PC   0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F 10 11 12 13 14 15 16 17 18 19 1A 1B 1C 1D 1E 1F
	# NUM 40 41 42 43 44 45 46 47 48 49 4A 4B 4C 4D 4E 4F 50 51 52 53 54 55 56 57 58 59 5A 5B 5C 5D 5E 5F

	DEFW GPIO_MODE_PPOUT, "GPIO-MODE-PPOUT"
	LIT GPIO_MODE_PPOUT
	ret
	ENDW GPIO_MODE_PPOUT

	DEFW GPIO_MODE_MUPPOUT, "GPIO-MODE-MUPPOUT"
	LIT GPIO_MODE_MUPPOUT
	ret
	ENDW GPIO_MODE_MUPPOUT

	DEFW GPIO_MODE_FLOATIN, "GPIO-MODE-FLOATIN"
	LIT GPIO_MODE_FLOATIN
	ret
	ENDW GPIO_MODE_FLOATIN

	DEFW GPIO_MODE_STORE, "GPIO-MODE!"
	# ( GPIO-MODE GPIO-NUM -- )
	li x14, 0x60
	rem x14, x15, x14
	lw x13, 0(x9)
	andi x13, x13, 0xF
	lw x15, 4(x9)
	addi x9, x9, 8

	# ENABLE GPIO BANK CLOCK
	li x12, RCC_BASE
	lw x12, R32_RCC_APB2PRSTR(x12)
	li x11, (1 << 2) # IOPARST BIT
	srli x10, x14, 5
	sll x11, x11, x10
	xori x11, x11, -1
	and x11, x12, x11
	li x12, RCC_BASE
	sw x11, R32_RCC_APB2PRSTR(x12)
	lw x12, R32_RCC_APB2PCENR(x12)
	li x11, (1 << 2) # IOPAEN BIT
	srli x10, x14, 5
	sll x11, x11, x10
	or x11, x12, x11
	li x12, RCC_BASE
	sw x11, R32_RCC_APB2PCENR(x12)

	andi x12, x14, 0x1F
	li x11, 0x18
	blt x12, x11, 1f
	# SKIP PIN-NUM HOLE
	ret
1:
	srli x12, x14, 5
	slli x12, x12, 10
	li x11, GPIOA_BASE
	add x12, x12, x11
	andi x11, x14, 0x1F
	srli x11, x11, 3
	li x10, 0x2
	blt x11, x10, 2f
	addi x11, x11, 5
2:
	slli x11, x11, 2
	add x12, x12, x11
	andi x11, x14, 0x7
	slli x11, x11, 2
	li x10, 0xF
	sll x11, x10, x11
	xori x11, x11, -1
	lw x10, 0(x12)
	and x10, x10, x11
	andi x11, x14, 0x7
	slli x11, x11, 2
	sll x13, x13, x11
	or x10, x10, x13
	sw x10, 0(x12)
	ret
	ENDW GPIO_MODE_STORE

	DEFW GPIO_OUT_STORE, "GPIO-OUT!"
	# ( FLAG GPIO-NUM -- )
	li x14, 0x60
	rem x14, x15, x14
	lw x13, 0(x9)
	lw x15, 4(x9)
	addi x9, x9, 8
	andi x12, x14, 0x1F
	slti x12, x12, 0x18
	bnez x12, 1f
	# SKIP PIN-NUM HOLE
	ret
1:
	srli x12, x14, 5
	slli x12, x12, 10
	li x11, (GPIOA_BASE + R32_GPIO_BSHR)
	add x12, x12, x11
	andi x11, x14, 0x1F
	slti x11, x11, 0x10
	bnez x11, 2f
	addi x12, x12, (R32_GPIO_BSXR - R32_GPIO_BSHR)
	addi x14, x14, -16
2:
	bnez x13, 3f
	addi x14, x14, 16
3:
	li x11, 1
	andi x14, x14, 0x1F
	sll x11, x11, x14
	sw x11, 0(x12)
	ret
	ENDW GPIO_OUT_STORE

	DEFW GPIO_OUT_LOAD, "GPIO-OUT@"
	# ( GPIO-NUM -- FLAG )
	li x14, 0x60
	rem x14, x15, x14
	andi x13, x15, 0x1F
	li x12, 0x18
	blt x13, x12, 1f
	# SKIP PIN-NUM HOLE
	li x15, 0
	ret
1:
	srli x13, x14, 5
	slli x13, x13, 10
	li x12, (GPIOA_BASE + R32_GPIO_OUTDR)
	add x12, x12, x13
	andi x14, x14, 0x1F
	li x11, 1
	sll x11, x11, x14
	lw x10, 0(x12)
	and x15, x10, x11
	beqz x15, 2f
	li x15, -1
2:
	ret
	ENDW GPIO_OUT_LOAD

	# HOW TO BLINK LED 1HZ ON PB12 BY FORTH WAY:
	#
	# : LED-INIT GPIO-MODE-PPOUT $2C GPIO-MODE! ;
	# LED-INIT
	# : TASK-BLINK BEGIN $3E8 DELAY $2C GPIO-OUT@ INVERT $2C GPIO-OUT! AGAIN ;
	# ' TASK-BLINK USER-NEW .

	DEFW GPIO_IN_LOAD, "GPIO-IN@"
	# ( GPIO-NUM -- FLAG )
	li x14, 0x60
	rem x14, x15, x14
	andi x13, x15, 0x1F
	li x12, 0x18
	blt x13, x12, 1f
	# SKIP PIN-NUM HOLE
	li x15, 0
	ret
1:
	srli x13, x14, 5
	slli x13, x13, 10
	li x12, (GPIOA_BASE + R32_GPIO_INDR)
	add x12, x12, x13
	andi x14, x14, 0x1F
	li x11, 1
	sll x11, x11, x14
	lw x10, 0(x12)
	and x15, x10, x11
	beqz x15, 2f
	li x15, -1
2:
	ret
	ENDW GPIO_IN_LOAD
