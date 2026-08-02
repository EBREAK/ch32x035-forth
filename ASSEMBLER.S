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

	DEFW CJ_TYPE, "CJ-TYPE"
	# ( IMM FUNCT3_OPCODE -- WINSTRUCTION )
	PPOP x14
	# 1111110000000000
	# 5432109876543210
	#             | |  # $E
	#           | |    # $38
	andi x13, x14, 0xE
	slli x13, x13, 2
	or x15, x15, x13
	# 1111110000000000
	# 5432109876543210
	#            ^     # $10
	#     ^            # $800
	andi x13, x14, 0x10
	slli x13, x13, 7
	or x15, x15, x13
	# 1111110000000000
	# 5432109876543210
	#           ^      # $20
	#              ^   # $4
	andi x13, x14, 0x20
	srli x13, x13, 3
	or x15, x15, x13
	# 1111110000000000
	# 5432109876543210
	#          ^       # $40
	#         ^        # $80
	andi x13, x14, 0x40
	slli x13, x13, 1
	or x15, x15, x13
	# 1111110000000000
	# 5432109876543210
	#         ^        # $80
	#          ^       # $40
	andi x13, x14, 0x80
	srli x13, x13, 1
	or x15, x15, x13
	# 1111110000000000
	# 5432109876543210
	#       ||         # $300
	#      ||          # $600
	andi x13, x14, 0x300
	slli x13, x13, 1
	or x15, x15, x13
	# 1111110000000000
	# 5432109876543210
	#      ^           # $400
	#        ^         # $100
	andi x13, x14, 0x400
	srli x13, x13, 2
	or x15, x15, x13
	# 1111110000000000
	# 5432109876543210
	#     ^            # $800
	#    ^             # $1000
	li x12, 0x800
	and x13, x14, x12
	slli x13, x13, 1
	or x15, x15, x13
	ret
	ENDW CJ_TYPE

	DEFW DIS_CJ_TYPE, "DIS-CJ-TYPE"
	# ( WINSTRUCTION -- IMM FUNCT3_OPCODE )
	# 1111110000000000
	# 5432109876543210
	#           | |    # $38
	#             | |  # $E
	andi x14, x15, 0x38
	srli x14, x14, 2
	# 1111110000000000
	# 5432109876543210
	#     ^            # $800
	#            ^     # $10
	srli x13, x15, 7
	andi x13, x13, 0x10
	or x14, x14, x13
	# 1111110000000000
	# 5432109876543210
	#              ^   # $4
	#           ^      # $20
	andi x13, x15, 0x4
	slli x13, x13, 3
	or x14, x14, x13
	# 1111110000000000
	# 5432109876543210
	#         ^        # $80
	#          ^       # $40
	andi x13, x15, 0x80
	srli x13, x13, 1
	or x14, x14, x13
	# 1111110000000000
	# 5432109876543210
	#          ^       # $40
	#         ^        # $80
	andi x13, x15, 0x40
	slli x13, x13, 1
	or x14, x14, x13
	# 1111110000000000
	# 5432109876543210
	#      ||          # $600
	#       ||         # $300
	andi x13, x15, 0x600
	srli x13, x13, 1
	or x14, x14, x13
	# 1111110000000000
	# 5432109876543210
	#        ^         # $100
	#      ^           # $400
	andi x13, x15, 0x100
	slli x13, x13, 2
	or x14, x14, x13
	# 1111110000000000
	# 5432109876543210
	#    ^             # $1000
	#     ^            # $800
	li x12, 0x1000
	and x13, x15, x12
	beqz x13, 1f
	li x13, 0xFFFFF800
1:
	or x14, x14, x13
	addi x9, x9, -4
	sw x14, 0(x9)
	li x14, 0xE003
	and x15, x15, x14
	ret
	ENDW DIS_CJ_TYPE

	DEFW CB_TYPE, "CB-TYPE"
	# ( IMM RD|RS1 FUNCT3_OPCODE -- WINSTURCTION )
	lw x14, 0(x9)
	addi x14, x14, -8
	andi x14, x14, 0x7
	slli x14, x14, 7
	or x15, x15, x14
	lw x14, 4(x9)
	addi x9, x9, 8
	# 1111110000000000
	# 5432109876543210
	#              ||  # $6
	#            ||    # $18
	andi x13, x14, 0x6
	slli x13, x13, 2
	or x15, x15, x13
	# 1111110000000000
	# 5432109876543210
	#            ||    # $18
	#     ||           # $C00
	andi x13, x14, 0x18
	slli x13, x13, 7
	or x15, x15, x13
	# 1111110000000000
	# 5432109876543210
	#           ^      # $20
	#              ^   # $4
	andi x13, x14, 0x20
	srli x13, x13, 3
	or x15, x15, x13
	# 1111110000000000
	# 5432109876543210
	#         ||       # $C0
	#          ||      # $60
	andi x13, x14, 0xC0
	srli x13, x13, 1
	or x15, x15, x13
	# 1111110000000000
	# 5432109876543210
	#        ^         # $100
	#    ^             # $1000
	andi x13, x14, 0x100
	slli x13, x13, 4
	or x15, x15, x13
	ret
	ENDW CB_TYPE

	DEFW DIS_CB_TYPE, "DIS-CB-TYPE"
	# ( WINSTRUCTION -- IMM RD|RS1 FUNCT3_OPCODE )
	addi x9, x9, -8
	srli x14, x15, 7
	andi x14, x14, 0x7
	addi x14, x14, 8
	sw x14, 0(x9)
	# 1111110000000000
	# 5432109876543210
	#            ||    # $18
	#              ||  # $6
	andi x14, x15, 0x18
	srli x14, x14, 2
	# 1111110000000000
	# 5432109876543210
	#     ||           # $C00
	#            ||    # $18
	srli x13, x15, 7
	andi x13, x13, 0x18
	or x14, x14, x13
	# 1111110000000000
	# 5432109876543210
	#              ^   # $4
	#           ^      # $20
	andi x13, x15, 0x4
	slli x13, x13, 3
	or x14, x14, x13
	# 1111110000000000
	# 5432109876543210
	#          ||      # $60
	#         ||       # $C0
	andi x13, x15, 0x60
	slli x13, x13, 1
	or x14, x14, x13
	# 1111110000000000
	# 5432109876543210
	#    ^             # $1000
	#        ^         # $100
	srli x13, x15, 4
	andi x13, x13, 0x100
	beqz x13, 1f
	li x13, 0xFFFFFF00
1:
	or x14, x14, x13
	sw x14, 4(x9)
	li x14, 0xE003
	and x15, x15, x14
	ret
	ENDW DIS_B_TYPE

	DEFW CA_TYPE, "CA-TYPE"
	# ( RD|RS1 RS2 FUNCT6_FUNCT2_OPCODE -- WINSTRUCTION )
	lw x14, 0(x9)
	addi x14, x14, -8
	andi x14, x14, 0x7
	slli x14, x14, 2
	or x15, x15, x14
	lw x14, 4(x9)
	addi x14, x14, -8
	andi x14, x14, 0x7
	slli x14, x14, 7
	or x15, x15, x14
	lw x14, 8(x9)
	addi x9, x9, 8
	ret
	ENDW CA_TYPE

	DEFW DIS_CA_TYPE, "DIS-CA-TYPE"
	# ( WINSTRUCTION -- RD|RS1 RS2 FUNCT6_FUNCT2_OPCODE )
	addi x9, x9, -8
	srli x14, x15, 2
	andi x14, x14, 0x7
	addi x14, x14, 8
	sw x14, 0(x9)
	srli x14, x15, 7
	andi x14, x14, 0x7
	addi x14, x14, 8
	sw x14, 4(x9)
	li x14, 0xFC63
	and x15, x15, x14
	ret
	ENDW DIS_CA_TYPE

	DEFW CSW_TYPE, "CSW-TYPE"
	# ( IMM RS1 RS2 FUNCT3_OPCODE -- WINSTRUCTION )
	lw x14, 0(x9)
	addi x14, x14, -8
	andi x14, x14, 0x7
	slli x14, x14, 2
	or x15, x15, x14
	lw x14, 4(x9)
	addi x14, x14, -8
	andi x14, x14, 0x7
	slli x14, x14, 7
	or x15, x15, x14
	lw x14, 8(x9)
	addi x9, x9, 12
	# 1111110000000000
	# 5432109876543210
	#              ^   # $4
	#          ^       # $40
	andi x13, x14, 0x4
	slli x13, x13, 4
	or x15, x15, x13
	# 1111110000000000
	# 5432109876543210
	#           | |    # $38
	#    | |           # $1C00
	andi x13, x14, 0x38
	slli x13, x13, 7
	or x15, x15, x13
	# 1111110000000000
	# 5432109876543210
	#          ^       # $40
	#           ^      # $20
	andi x13, x14, 0x40
	srli x13, x13, 1
	or x15, x15, x13
	ret
	ENDW CSW_TYPE

	DEFW DIS_CSW_TYPE, "DIS-CSW-TYPE"
	# ( WINSTRUCTION -- IMM RS1 RS2 FUNCT3_OPCODE )
	addi x9, x9, -12
	srli x14, x15, 2
	andi x14, x14, 0x7
	addi x14, x14, 8
	sw x14, 0(x9)
	srli x14, x15, 7
	andi x14, x14, 0x7
	addi x14, x14, 8
	sw x14, 4(x9)
	# 1111110000000000
	# 5432109876543210
	#          ^       # $40
	#              ^   # $4
	andi x14, x15, 0x40
	srli x14, x14, 4
	# 1111110000000000
	# 5432109876543210
	#    | |           # $1C00
	#           | |    # $38
	srli x13, x15, 7
	andi x13, x13, 0x38
	or x14, x14, x13
	# 1111110000000000
	# 5432109876543210
	#           ^      # $20
	#          ^       # $40
	andi x13, x15, 0x20
	slli x13, x13, 1
	or x14, x14, x13
	sw x14, 8(x9)
	li x14, 0xE003
	and x15, x15, x14
	ret
	ENDW DIS_CSW_TYPE

	DEFW CLW_TYPE, "CLW-TYPE"
	# ( IMM RS1 RD FUNCT3_OPCODE -- WINSTRUCTION )
	TC CSW_TYPE
	ENDW CLW_TYPE

	DEFW DIS_CLW_TYPE, "DIS-CLW-TYPE"
	# ( WINSTRUCTION -- IMM RS1 RD FUNCT3_OPCODE )
	TC DIS_CSW_TYPE
	ENDW DIS_CLW_TYPE

	DEFW CI_TYPE, "CI-TYPE"
	# ( IMM RD|RS1 FUNCT3_OPCODE -- WINSTRUCTION )
	lw x14, 0(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 7
	or x15, x15, x14
	lw x14, 4(x9)
	addi x9, x9, 8
	# 1111110000000000
	# 5432109876543210
	#            |   | # $1F
	#          |   |   # $7C
	andi x13, x14, 0x1F
	slli x13, x13, 2
	or x15, x15, x13
	# 1111110000000000
	# 5432109876543210
	#           ^      # $20
	#    ^             # $1000
	andi x13, x14, 0x20
	slli x13, x13, 7
	or x15, x15, x13
	ret
	ENDW CI_TYPE

	DEFW DIS_CI_TYPE, "DIS-CI-TYPE"
	# ( WINSTRUCTION -- IMM RD|RS1 FUNCT3_OPCODE )
	addi x9, x9, -8
	srli x14, x15, 7
	andi x14, x14, 0x1F
	sw x14, 0(x9)
	# 1111110000000000
	# 5432109876543210
	#          |   |   # $7C
	#            |   | # $1F
	andi x14, x15, 0x7C
	srli x14, x14, 2
	# 1111110000000000
	# 5432109876543210
	#    ^             # $1000
	#           ^      # $20
	srli x13, x15, 7
	andi x13, x13, 0x20
	beqz x13, 1f
	li x13, 0xFFFFFFE0
1:
	or x14, x14, x13
	sw x14, 4(x9)
	li x14, 0xE003
	and x15, x15, x14
	ret
	ENDW DIS_CI_TYPE

	DEFW CR_TYPE, "CR-TYPE"
	# ( RD|RS1 RS2 FUNCT4_OPCODE -- WINSTRUCTION )
	lw x14, 0(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 2
	or x15, x15, x14
	lw x14, 4(x9)
	andi x14, x14, 0x1F
	slli x14, x14, 7
	or x15, x15, x14
	addi x9, x9, 8
	ret
	ENDW CR_TYPE

	DEFW DIS_CR_TYPE, "DIS-CR-TYPE"
	# ( WINSTRUCTION -- RD|RS1 RS2 FUNCT4_OPCODE )
	addi x9, x9, -8
	srli x14, x15, 2
	andi x14, x14, 0x1F
	sw x14, 0(x9)
	srli x14, x15, 7
	andi x14, x14, 0x1F
	sw x14, 4(x9)
	li x14, 0xF003
	and x15, x15, x14
	ret
	ENDW DIS_CR_TYPE
