	DEFW J_TYPE, "J-TYPE"
	# ( IMM RD OPCODE -- LINSTRUCTION )
	lw x14, 0(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 7
	or x15, x15, x14
	lw x14, 4(x9)
	addi x9, x9, 8
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	#                      |        |  $7FE
	#  |        |                      $7FE00000
	andi x13, x14, 0x7FE
	slli x13, x13, 20
	or x15, x15, x13
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	#                     ^            $800
	#            ^                     $100000
	li x12, (1 << 11)
	and x13, x14, x12
	slli x13, x13, 9
	or x15, x15, x13
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	#             |      |             $FF000
	#             |      |             $FF000
	li x12, 0xFF000
	and x13, x14, x12
	or x15, x15, x13
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	#            ^                     $100000
	# ^                                $80000000
	li x12, (1 << 20)
	and x13, x14, x12
	slli x13, x13, 11
	or x15, x15, x13
	ret
	ENDW J_TYPE

	DEFW U_TYPE, "U-TYPE"
	# ( IMM RD OPCODE -- LINSTRUCTION )
	lw x14, 0(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 7
	or x15, x15, x14
	lw x14, 4(x9)
	li x13, 0xFFFFF000
	and x14, x14, x13
	or x15, x15, x14
	addi x9, x9, 8
	ret
	ENDW U_TYPE

