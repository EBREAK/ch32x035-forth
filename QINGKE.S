	DEFW SYS_RESET, "SYS-RESET"
	# ( -- )
	li x14, (PFIC_BASE + R32_PFIC_SCTLR)
	li x13, (0xBEEF << 16) | (1 << 7)
	sw x13, 0(x14)
	j .
	ENDW SYS_RESET

	DEFW IRQN_SYSTICK, "IRQN-SYSTICK"
	LIT IRQN_SYSTICK
	ret
	ENDW IRQN_SYSTICK

	DEFW IRQN_USART1, "IRQN-USART1"
	LIT IRQN_USART1
	ret
	ENDW IRQN_USART1

	DEFW IRQN_USART2, "IRQN-USART2"
	LIT IRQN_USART2
	ret
	ENDW IRQN_USART2

	DEFW IRQN_USART3, "IRQN-USART3"
	LIT IRQN_USART3
	ret
	ENDW IRQN_USART3

	DEFW IRQN_USART4, "IRQN-USART4"
	LIT IRQN_USART4
	ret
	ENDW IRQN_USART4

	DEFW IRQN_USBFS, "IRQN-USBFS"
	LIT IRQN_USBFS
	ret
	ENDW IRQN_USBFS

	DEFW IRQN_PIOC, "IRQN-PIOC"
	LIT IRQN_PIOC
	ret
	ENDW IRQN_PIOC

	DEFW PIFC_IRQ_ISEN, "PFIC-IRQ-EN?"
	# ( IRQN -- FLAG )
	li x14, (PFIC_BASE + R32_PFIC_ISR1)
	srli x13, x15, 5
	slli x13, x13, 2
	add x14, x14, x13
	andi x13, x15, 0x1F
	li x12, 1
	sll x12, x12, x13
	lw x11, 0(x14)
	and x11, x11, x12
	li x15, -1
	bnez x11, 1f
	li x15, 0
1:
	ret
	ENDW PFIC_IRQ_ISEN

	DEFW PFIC_IRQ_EN, "PFIC-IRQ-EN"
	# ( IRQN -- )
	fence.i
	li x14, (PFIC_BASE + R32_PFIC_IENR1)
	srli x13, x15, 5
	slli x13, x13, 2
	add x14, x14, x13
	andi x13, x15, 0x1F
	li x12, 1
	sll x12, x12, x13
	sw x12, 0(x14)
	fence.i
	PPOP x15
	ret
	ENDW PFIC_IRQ_EN

	DEFW PFIC_IRQ_DIS, "PFIC-IRQ-DIS"
	# ( IRQN -- )
	fence.i
	li x14, (PFIC_BASE + R32_PFIC_IRER1)
	srli x13, x15, 5
	slli x13, x13, 2
	add x14, x14, x13
	andi x13, x15, 0x1F
	li x12, 1
	sll x12, x12, x13
	sw x12, 0(x14)
	fence.i
	PPOP x15
	ret
	ENDW PFIC_IRQ_DIS

	DEFW ISR_VECTAB_LOAD, "ISR-VECTAB@"
	# ( IRQN -- CODE-ADDR )
	csrr x14, mtvec
	xori x14, x14, 0x3 # WE ONLY USE VECTOR TABLE MODE
	slli x15, x15, 2
	add x14, x14, x15
	lw x15, 0(x14)
	ret
	ENDW ISR_VECTAB_LOAD

	DEFW ISR_VECTAB_STORE, "ISR-VECTAB!"
	# ( CODE-ADDR IRQN -- )
	mv x14, x15
	lw x13, 0(x9)
	lw x15, 4(x9)
	addi x9, x9, 8
	csrr x12, mtvec
	xori x12, x12, 0x3 # WE ONLY USE VECTOR TABLE MODE
	slli x14, x14, 2
	add x12, x12, x14
	sw x13, 0(x12)
	ret
	ENDW ISR_VECTAB_STORE
