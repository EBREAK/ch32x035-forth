	DEFW SYSCLK_LOAD, "SYSCLK@"
	# ( -- HZ )
	PPUSH x15
	li x14, RCC_BASE
	lw x13, R32_RCC_CFGR0(x14)
	srli x13, x13, 4
	andi x13, x13, 0xF
	.PUSHSECTION .rodata
HPRE_DIV_LUT:
	.BYTE 1, 2, 3, 4, 5, 6, 7, 8
	.BYTE 2, 4, 8, 16, 32, 64, 128, 256
	.POPSECTION
	la x12, HPRE_DIV_LUT
	add x12, x12, x13
	lbu x13, 0(x12)
	li x15, (48 * 1000 * 1000) # HSI 48Mhz
	div x15, x15, x13
	ret
	ENDW SYSCLK_LOAD
