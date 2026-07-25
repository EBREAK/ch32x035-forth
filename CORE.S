	DEFW NOOP, "NOOP"
	ret
	ENDW NOOP

	DEFW FALSE, "FALSE"
	PPUSH x15
	mv x15, x0
	ret
	ENDW FALSE

	DEFW TRUE, "TRUE"
	PPUSH x15
	li x15, -1
	ret
	ENDW TRUE

	DEFW DROP, "DROP"
	PPOP x15
	ret
	ENDW DROP

	DEFW DUP, "DUP"
	PPUSH x15
	ret
	ENDW DUP

	DEFW NIP, "NIP"
	addi x9, x9, 4
	ret
	ENDW NIP

	DEFW SWAP, "SWAP"
	mv x14, x15
	lw x15, 0(x9)
	sw x14, 0(x9)
	ret
	ENDW SWAP

	DEFW OVER, "OVER"
	PPUSH x15
	lw x15, 4(x9)
	ret
	ENDW OVER

	DEFW ROT, "ROT"
	mv x14, x15
	lw x13, 0(x9)
	lw x15, 4(x9)
	sw x13, 4(x9)
	sw x14, 0(x9)
	ret
	ENDW ROT

	DEFW PICK, "PICK"
	slli x14, x15, 2
	add x14, x14, x9
	lw x15, 0(x14)
	ret
	ENDW PICK

	DEFW TOR, ">R"
	RPUSH x15
	PPOP x15
	ret
	ENDW TOR

	DEFW FROMR, "R>"
	PPUSH x15
	RPOP x15
	ret
	ENDW FROMR

	DEFW 2DROP, "2DROP"
	lw x15, 4(x9)
	addi x9, x9, 8
	ret
	ENDW 2DROP

	DEFW 2NIP, "2NIP"
	lw x14, 0(x9)
	addi x9, x9, 8
	sw x14, 0(x9)
	ret
	ENDW 2NIP

	DEFW 2DUP, "2DUP"
	lw x14, 0(x9)
	addi x9, x9, -8
	sw x14, 0(x9)
	sw x15, 4(x9)
	ret
	ENDW 2DUP

	DEFW 2SWAP, "2SWAP"
	lw x14, 0(x9)
	lw x13, 4(x9)
	lw x12, 8(x9)
	sw x15, 4(x9)
	mv x15, x13
	sw x14, 8(x9)
	sw x12, 0(x9)
	ret
	ENDW 2SWAP

	DEFW 2OVER, "2OVER"
	RPUSH x1
	FC TOR, TOR, 2DUP, FROMR, FROMR
	RPOP x1
	TC 2SWAP
	ENDW 2OVER

	DEFW 2ROT, "2ROT"
	RPUSH x1
	FC TOR, TOR, 2SWAP, FROMR, FROMR
	RPOP x1
	TC 2SWAP
	ENDW 2ROT

	DEFW 2NROT, "2-ROT"
	RPUSH x1
	FC 2SWAP, TOR, TOR, 2SWAP, FROMR, FROMR
	RPOP x1
	ret
	ENDW 2NROT
	
	DEFW EQ, "="
	mv x14, x15
	PPOP x13
	li x15, -1
	beq x13, x14, 1f
	li x15, 0
1:
	ret
	ENDW EQ

	DEFW 3DROP, "3DROP"
	lw x15, 8(x9)
	addi x9, x9, 12
	ret
	ENDW 3DROP

	DEFW NE, "<>"
	mv x14, x15
	PPOP x13
	li x15, -1
	bne x13, x14, 1f
	li x15, 0
1:
	ret
	ENDW NE

	DEFW EQZ, "0="
	mv x14, x15
	li x15, -1
	beqz x14, 1f
	li x15, 0
1:
	ret
	ENDW EQZ

	DEFW NEZ, "0<>"
	mv x14, x15
	li x15, -1
	bnez x14, 1f
	li x15, 0
1:
	ret
	ENDW NEZ

	DEFW LT, "<"
	mv x14, x15
	PPOP x13
	li x15, -1
	blt x13, x14, 1f
	li x15, 0
1:
	ret
	ENDW LT

	DEFW LTZ, "0<"
	mv x14, x15
	li x15, -1
	bltz x14, 1f
	li x15, 0
1:
	ret
	ENDW LTZ

	DEFW GT, ">"
	mv x14, x15
	PPOP x13
	li x15, -1
	bgt x13, x14, 1f
	li x15, 0
1:
	ret
	ENDW GT

	DEFW GTZ, "0>"
	mv x14, x15
	li x15, -1
	bgtz x14, 1f
	li x15, 0
1:
	ret
	ENDW GTZ

	DEFW ULT, "U<"
	mv x14, x15
	PPOP x13
	li x15, -1
	bltu x13, x14, 1f
	li x15, 0
1:
	ret
	ENDW ULT

	DEFW UGT, "U>"
	mv x14, x15
	PPOP x13
	li x15, -1
	bgtu x13, x14, 1f
	li x15, 0
1:
	ret
	ENDW UGT

	DEFW PLUS, "+"
	PPOP x14
	add x15, x14, x15
	ret
	ENDW PLUS

	DEFW MINUS, "-"
	PPOP x14
	sub x15, x14, x15
	ret
	ENDW MINUS

	DEFW MULTI, "*"
	PPOP x14
	mul x15, x14, x15
	ret
	ENDW MULTI

	DEFW DIVID, "/"
	PPOP x14
	div x15, x14, x15
	ret
	ENDW DIVID

	DEFW MOD, "MOD"
	PPOP x14
	rem x15, x14, x15
	ret
	ENDW MOD

	DEFW LSHIFT, "LSHIFT"
	PPOP x14
	sll x15, x14, x15
	ret
	ENDW LSHIFT

	DEFW RSHIFT, "RSHIFT"
	PPOP x14
	srl x15, x14, x15
	ret
	ENDW RSHIFT

	DEFW AND, "AND"
	PPOP x14
	and x15, x14, x15
	ret
	ENDW AND

	DEFW OR, "OR"
	PPOP x14
	or x15, x14, x15
	ret
	ENDW OR

	DEFW XOR, "XOR"
	PPOP x14
	xor x15, x14, x15
	ret
	ENDW XOR

	DEFW INVERT, "INVERT"
	xor x15, x15, -1
	ret
	ENDW INVERT

	DEFW NEGATE, "NEGATE"
	xor x15, x15, -1
	addi x15, x15, 1
	ret
	ENDW NEGATE

	DEFW CLOAD, "C@"
	lbu x15, 0(x15)
	ret
	ENDW CLOAD

	DEFW WLOAD, "W@"
	andi x14, x15, 1
	bnez x14, 1f
	lhu x15, 0(x15)
	ret
1:
	lbu x14, 0(x15)
	lbu x13, 1(x15)
	slli x13, x13, 8
	or x15, x13, x14
	ret
	ENDW WLOAD

	DEFW LLOAD, "L@"
	andi x14, x15, 3
	bnez x14, 1f
	lw x15, 0(x15)
	ret
1:
	andi x14, x15, 1
	bnez x14, 2f
	lhu x14, 0(x15)
	lhu x13, 2(x15)
	slli x13, x13, 16
	or x15, x13, x14
	ret
2:
	lbu x14, 0(x15)
	lbu x13, 1(x15)
	slli x13, x13, 8
	or x14, x13, x14
	lbu x13, 2(x15)
	slli x13, x13, 16
	or x14, x13, x14
	lbu x13, 3(x15)
	slli x13, x13, 24
	or x15, x13, x14
	ret	
	ENDW LLOAD

	DEFW LOAD, "@"
	TC LLOAD
	ENDW LOAD

	DEFW DP, "DP"
	.PUSHSECTION .data
	.P2ALIGN 2, 0
FORTH_DP:
	.4BYTE _forth_code_ram_start
	.POPSECTION
	PPUSH x15
	la x15, FORTH_DP
	ret
	ENDW DP

	DEFW HERE, "HERE"
	PPUSH x15
	la x15, FORTH_DP
	lw x15, 0(x15)
	ret
	ENDW HERE

	DEFW PAD, "PAD"
	PPUSH x15
	la x15, FORTH_DP
	lw x15, 0(x15)
	addi x15, x15, 256
	ret
	ENDW PAD

	DEFW CSTORE, "C!"
	mv x14, x15
	lw x13, 0(x9)
	lw x15, 4(x9)
	addi x9, x9, 8
	sb x13, 0(x14)
	ret
	ENDW CSTORE

	DEFW WSTORE, "W!"
	mv x14, x15
	lw x13, 0(x9)
	lw x15, 4(x9)
	addi x9, x9, 8
	andi x12, x14, 0x1
	beqz x12, 1f
	sb x13, 0(x14)
	srli x13, x13, 8
	sb x13, 1(x14)
	ret
1:
	sh x13, 0(x14)
	ret
	ENDW WSTORE

	DEFW LSTORE, "L!"
	mv x14, x15
	lw x13, 0(x9)
	lw x15, 4(x9)
	addi x9, x9, 8
	andi x12, x14, 0x3
	beqz x12, 2f
	andi x12, x14, 0x1
	beqz x12, 1f
	sb x13, 0(x14)
	srli x13, x13, 8
	sb x13, 1(x14)
	srli x13, x13, 8
	sb x13, 2(x14)
	srli x13, x13, 8
	sb x13, 3(x14)
	ret
1:
	sh x13, 0(x14)
	srli x13, x13, 16
	sh x13, 2(x14)
	ret
2:
	sw x13, 0(x14)
	ret
	ENDW LSTORE

	DEFW STORE, "!"
	TC LSTORE
	ENDW STORE

	DEFW EXECUTE, "EXECUTE"
	mv x14, x15
	PPOP x15
	jr x14
	ENDW EXECUTE

	DEFW UPLOAD, "UP@"
	PPUSH x15
	mv x15, x4
	ret
	ENDW UPLOAD

	DEFW PAUSE, "PAUSE"
	sw x1, USER_RAS(x4)
	sw x15, USER_TOS(x4)
	sw x9, USER_PSP(x4)
	sw x8, USER_RSP(x4)
	lw x4, USER_NXT(x4)
	lw x1, USER_RAS(x4)
	lw x15, USER_TOS(x4)
	lw x9, USER_PSP(x4)
	lw x8, USER_RSP(x4)
	ret
	ENDW PAUSE

	DEFW DEPTH, "DEPTH"
	lw x14, USER_PS0(x4)
	sub x13, x14, x9
	PPUSH x15
	srli x15, x13, 2
	ret
	ENDW DEPTH

	DEFW ABORT, "ABORT"
	li x15, TOS_INIT
	lw x9, USER_PS0(x4)
	lw x8, USER_RS0(x4)
	lw x1, USER_SAV(x4)
	ret
	ENDW ABORT
