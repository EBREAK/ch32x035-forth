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

	DEFW DIS_J_TYPE, "DIS-J-TYPE"
	# ( LINSTRUCTION -- IMM RD OPCODE )
	addi x9, x9, -8
	srli x14, x15, 7
	andi x14, x14, 0x1F
	sw x14, 0(x9)
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	#  |        |                      $7FE00000
	#                      |        |  $7FE
	srli x14, x15, 20
	andi x14, x14, 0x7FE
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	#            ^                     $100000
	#                     ^            $800
	srli x13, x15, 9
	li x12, 0x800
	and x13, x13, x12
	or x14, x14, x13
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	#             |      |             $FF000
	#             |      |             $FF000
	li x12, 0xFF000
	and x13, x15, x12
	or x14, x14, x13
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	# ^                                $80000000
	#            ^                     $100000 (WITH SIGN EXTEND)
	srli x13, x15, 11
	li x12, (1 << 20)
	and x13, x13, x12
	beqz x13, 1f
	li x13, 0xFFF00000
1:
	or x14, x14, x13
	sw x14, 4(x9)
	andi x15, x15, 0x7F
	ret
	ENDW DIS_J_TYPE

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

	DEFW DIS_U_TYPE, "DIS-U-TYPE"
	# ( LINSTRUCTION -- IMM RD OPCODE )
	addi x9, x9, -8
	srli x14, x15, 7
	andi x14, x14, 0x1F
	sw x14, 0(x9)
	li x13, 0xFFFFF000
	and x14, x15, x13
	sw x14, 4(x9)
	andi x15, x15, 0x7F
	ret
	ENDW DIS_U_TYPE

	DEFW B_TYPE, "B-TYPE"
	# ( IMM RS2 RS1 FUNCT3_OPCODE -- LINSTRUCTION )
	lw x14, 0(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 15
	or x15, x15, x14
	lw x14, 4(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 20
	or x15, x15, x14
	lw x14, 8(x9)
	addi x9, x9, 12
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

	DEFW DIS_B_TYPE, "DIS-B-TYPE"
	# ( LINSTRUCTION -- IMM RS2 RS1 FUNCT3_OPCODE )
	addi x9, x9, -12
	srli x14, x15, 15
	andi x14, x14, 0x1F
	sw x14, 0(x9)
	srli x14, x15, 20
	andi x14, x14, 0x1F
	sw x14, 4(x9)
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	#                     |  |         $F00
	#                            |  |  $1E
	srli x14, x15, 7
	andi x14, x14, 0x1E
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	#  |    |                          $7E000000
	#                      |    |      $7E0
	srli x13, x15, 20
	andi x13, x13, 0x7E0
	or x14, x14, x13
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	#                         ^        $80
	#                     ^            $800
	andi x13, x15, 0x80
	slli x13, x13, 4
	or x14, x14, x13
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	# ^                                $80000000
	#                    ^             $1000
	srli x13, x15, 19
	li x12, 0x1000
	and x13, x13, x12
	beqz x13, 1f
	li x13, 0xFFFFF000
1:
	or x14, x14, x13
	sw x14, 8(x9)
	li x14, 0x707F
	and x15, x15, x14
	ret
	ENDW DIS_B_TYPE

	DEFW S_TYPE, "S-TYPE"
	# ( IMM RS2 RS1 FUNCT3_OPCODE -- LINSTRUCTION )
	lw x14, 0(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 15
	or x15, x15, x14
	lw x14, 4(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 20
	or x15, x15, x14
	lw x14, 8(x9)
	addi x9, x9, 12
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

	DEFW DIS_S_TYPE, "DIS-S-TYPE"
	# ( LINSTRUCTION -- IMM RS2 RS1 FUNCT3_OPCODE )
	addi x9, x9, -12
	srli x14, x15, 15
	andi x14, x14, 0x1F
	sw x14, 0(x9)
	srli x14, x15, 20
	andi x14, x14, 0x1F
	sw x14, 4(x9)
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	#                     |   |        $F80
	#                            |   | $1F
	srli x14, x15, 7
	andi x14, x14, 0x1F
	# 33222222222211111111110000000000
	# 10987654321098765432109876543210
	# |     |                          $FE000000
	#                     |     |      $FE0
	srli x13, x15, 20
	li x12, 0xFE0
	and x13, x13, x12
	or x14, x14, x13
	li x13, (1 << 11)
	and x13, x14, x13
	beqz x13, 1f
	li x13, 0xFFFFF800
	or x14, x14, x13
1:
	sw x14, 8(x9)
	li x14, 0x707F
	and x15, x15, x14
	ret
	ENDW DIS_S_TYPE

	DEFW I_TYPE, "I-TYPE"
	# ( IMM RS1 RD FUNCT3_OPCODE -- LINSTRUCTION )
	lw x14, 0(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 7
	or x15, x15, x14
	lw x14, 4(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 15
	or x15, x15, x14
	lw x14, 8(x9)
	addi x9, x9, 12
	slli x14, x14, 20
	or x15, x15, x14
	ret
	ENDW I_TYPE

	DEFW DIS_I_TYPE, "DIS-I-TYPE"
	# ( LINSTRUCTION -- IMM RS1 RD FUNCT3_OPCODE )
	addi x9, x9, -12
	srli x14, x15, 7
	andi x14, x14, 0x1F
	sw x14, 0(x9)
	srli x14, x15, 15
	andi x14, x14, 0x1F
	sw x14, 4(x9)
	srli x14, x15, 20
	li x13, (1 << 11)
	and x13, x14, x13
	beqz x13, 1f
	li x13, 0xFFFFF800
	or x14, x14, x13
1:
	sw x14, 8(x9)
	li x14, 0x707F
	and x15, x15, x14
	ret
	ENDW DIS_I_TYPE

	DEFW R_TYPE, "R-TYPE"
	# ( RS2 RS1 RD FUNCT7_FUNCT3_OPCODE -- LINSTRUCTION )
	lw x14, 0(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 7
	or x15, x15, x14
	lw x14, 4(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 15
	or x15, x15, x14
	lw x14, 8(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 20
	or x15, x15, x14
	addi x9, x9, 12
	ret
	ENDW R_TYPE

	DEFW DIS_R_TYPE, "DIS-R-TYPE"
	# ( LINSTRUCTION -- RS2 RS1 RD FUNCT7_FUNCT3_OPCODE )
	addi x9, x9, -12
	srli x14, x15, 7
	andi x14, x14, 0x1F
	sw x14, 0(x9)
	srli x14, x15, 15
	andi x14, x14, 0x1F
	sw x14, 4(x9)
	srli x14, x15, 20
	andi x14, x14, 0x1F
	sw x14, 8(x9)
	li x14, 0xFE00707F
	and x15, x15, x14
	ret
	ENDW DIS_R_TYPE
