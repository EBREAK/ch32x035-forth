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

	DEFW B_TYPE, "B-TYPE"
	# ( IMM RS2 RS1 FUNCT3 OPCODE -- LINSTRUCTION )
	lw x14, 0(x9)
	andi x14, x14, 0x7
	slli x14, x14, 12
	or x15, x15, x14
	lw x14, 4(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 15
	or x15, x15, x14
	lw x14, 8(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 20
	or x15, x15, x14
	lw x14, 12(x9)
	addi x9, x9, 16
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	#                            |  |  $1E
	#                     |  |         $F00
	andi x13, x14, 0x1E
	slli x13, x13, 7
	or x15, x15, x13
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	#                      |    |      $7E0
	#  |    |                          $7E000000
	andi x13, x14, 0x7E0
	slli x13, x13, 20
	or x15, x15, x13
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	#                     ^            $800
	#                         ^        $80
	srli x13, x14, 4
	andi x13, x13, 0x80
	or x15, x15, x13
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	#                    ^             $1000
	# ^                                $80000000
	li x13, 0x1000
	and x13, x14, x13
	slli x13, x13, 19
	or x15, x15, x13
	ret
	ENDW B_TYPE

	DEFW S_TYPE, "S-TYPE"
	# ( IMM RS2 RS1 FUNCT3 OPCODE -- LINSTRUCTION )
	lw x14, 0(x9)
	andi x14, x14, 0x7
	slli x14, x14, 12
	or x15, x15, x14
	lw x14, 4(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 15
	or x15, x15, x14
	lw x14, 8(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 20
	or x15, x15, x14
	lw x14, 12(x9)
	addi x9, x9, 16
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	#                            |   | $1F
	#                     |   |        $F80
	andi x13, x14, 0x1F
	slli x13, x13, 7
	or x15, x15, x13
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	#                     |     |      $FE0
	# |     |                          $FE000000
	li x12, 0xFE0
	and x13, x14, x12
	slli x13, x13, 20
	or x15, x15, x13
	ret
	ENDW S_TYPE

	DEFW I_TYPE, "I-TYPE"
	# ( IMM RS1 FUNCT3 RD OPCODE -- LINSTRUCTION )
	lw x14, 0(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 7
	or x15, x15, x14
	lw x14, 4(x9)
	andi x14, x14, 0x7
	slli x14, x14, 12
	or x15, x15, x14
	lw x14, 8(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 15
	or x15, x15, x14
	lw x14, 12(x9)
	addi x9, x9, 16
	slli x14, x14, 20
	or x15, x15, x14
	ret
	ENDW I_TYPE
