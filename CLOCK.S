	DEFW SYSCLK_LOAD, "SYSCLK@"
	# ( -- HZ )
	PPUSH x15
	li x14, RCC_BASE
	lw x13, R32_RCC_CFGR0(x14)
	srli x13, x13, 4
	andi x13, x13, 0xF
	addi x13, x13, 1
	li x15, (48 * 1000 * 1000) # HSI 48Mhz
	div x15, x15, x13
	ret
	ENDW SYSCLK_LOAD
