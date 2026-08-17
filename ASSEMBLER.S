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

	DEFW L_JAL, "L.JAL,"
	# ( OFFSET RD -- )
	LIT 0B1101111
	RPUSH x1
	FC J_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_JAL

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

	DEFW L_LUI, "L.LUI,"
	LIT 0B0110111
	RPUSH x1
	FC U_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_LUI

	DEFW L_AUIPC, "L.AUIPC,"
	LIT 0B0010111
	RPUSH x1
	FC U_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_AUIPC

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

	DEFW L_BEQ, "L.BEQ,"
	LIT 0B1100011
	RPUSH x1
	FC B_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_BEQ

	DEFW L_BNE, "L.BNE,"
	LIT ((0X1 << 12) | 0B1100011)
	RPUSH x1
	FC B_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_BNE

	DEFW L_BLT, "L.BLT,"
	LIT ((0X4 << 12) | 0B1100011)
	RPUSH x1
	FC B_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_BLT

	DEFW L_BGE, "L.BGE,"
	LIT ((0X5 << 12) | 0B1100011)
	RPUSH x1
	FC B_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_BGE

	DEFW L_BLTU, "L.BLTU,"
	LIT ((0X6 << 12) | 0B1100011)
	RPUSH x1
	FC B_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_BLTU

	DEFW L_BGEU, "L.BGEU,"
	LIT ((0X7 << 12) | 0B1100011)
	RPUSH x1
	FC B_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_BGEU

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

	DEFW L_SB, "L.SB,"
	LIT ((0X0 << 12) | 0B0100011)
	RPUSH x1
	FC S_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_SB

	DEFW L_SH, "L.SH,"
	LIT ((0X1 << 12) | 0B0100011)
	RPUSH x1
	FC S_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_SH

	DEFW L_SW, "L.SW,"
	LIT ((0X2 << 12) | 0B0100011)
	RPUSH x1
	FC S_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_SW

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

	DEFW L_LB, "L.LB,"
	LIT ((0X0 << 12) | 0B0000011)
	RPUSH x1
	FC I_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_LB

	DEFW L_LH, "L.LH,"
	LIT ((0X1 << 12) | 0B0000011)
	RPUSH x1
	FC I_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_LH

	DEFW L_LW, "L.LW,"
	LIT ((0X2 << 12) | 0B0000011)
	RPUSH x1
	FC I_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_LW

	DEFW L_LBU, "L.LBU,"
	LIT ((0X4 << 12) | 0B0000011)
	RPUSH x1
	FC I_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_LBU

	DEFW L_LHU, "L.LHU,"
	LIT ((0X5 << 12) | 0B0000011)
	RPUSH x1
	FC I_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_LHU

	DEFW L_ADDI, "L.ADDI,"
	LIT ((0X0 << 12) | 0B0010011)
	RPUSH x1
	FC I_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_ADDI

	DEFW L_SLLI, "L.SLLI,"
	LIT ((0X1 << 12) | 0B0010011)
	RPUSH x1
	FC I_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_SLLI

	DEFW L_SLTI, "L.SLTI,"
	LIT ((0X2 << 12) | 0B0010011)
	RPUSH x1
	FC I_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_SLTI

	DEFW L_SLTIU, "L.SLTIU,"
	LIT ((0X3 << 12) | 0B0010011)
	RPUSH x1
	FC I_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_SLTIU

	DEFW L_XORI, "L.XORI,"
	LIT ((0X4 << 12) | 0B0010011)
	RPUSH x1
	FC I_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_XORI

	DEFW L_SRLI, "L.SRLI,"
	LIT ((0X5 << 12) | 0B0010011)
	RPUSH x1
	FC I_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_SRLI

	DEFW L_SRAI, "L.SRAI,"
	li x14, (0x20 << 5)
	lw x13, 4(x9)
	or x13, x13, x14
	sw x13, 4(x9)
	LIT ((0X5 << 12) | 0B0010011)
	RPUSH x1
	FC I_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_SRAI

	DEFW L_ORI, "L.ORI,"
	LIT ((0X6 << 12) | 0B0010011)
	RPUSH x1
	FC I_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_ORI

	DEFW L_ANDI, "L.ANDI,"
	LIT ((0X7 << 12) | 0B0010011)
	RPUSH x1
	FC I_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_ANDI

	DEFW L_JALR, "L.JALR,"
	LIT ((0X0 << 12) | 0B1100111)
	RPUSH x1
	FC I_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_JALR

	DEFW L_ECALL, "L.ECALL,"
	LIT 0x00000073
	TC LCOMMA
	ENDW L_ECALL

	DEFW L_EBREAK, "L.EBREAK,"
	LIT 0x00100073
	TC LCOMMA
	ENDW L_EBREAK



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

	DEFW L_ADD, "L.ADD,"
	LIT ((0x0 << 25) | (0X0 << 12) | 0B0110011)
	RPUSH x1
	FC R_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_ADD

	DEFW L_SUB, "L.SUB,"
	LIT ((0x20 << 25) | (0X0 << 12) | 0B0110011)
	RPUSH x1
	FC R_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_SUB

	DEFW L_SLL, "L.SLL,"
	LIT ((0x00 << 25) | (0X1 << 12) | 0B0110011)
	RPUSH x1
	FC R_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_SLL

	DEFW L_SLT, "L.SLT,"
	LIT ((0x00 << 25) | (0X2 << 12) | 0B0110011)
	RPUSH x1
	FC R_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_SLT

	DEFW L_SLTU, "L.SLTU,"
	LIT ((0x00 << 25) | (0X3 << 12) | 0B0110011)
	RPUSH x1
	FC R_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_SLTU

	DEFW L_XOR, "L.XOR,"
	LIT ((0x00 << 25) | (0X4 << 12) | 0B0110011)
	RPUSH x1
	FC R_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_XOR

	DEFW L_SRL, "L.SRL,"
	LIT ((0x00 << 25) | (0X5 << 12) | 0B0110011)
	RPUSH x1
	FC R_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_SRL

	DEFW L_SRA, "L.SRA,"
	LIT ((0x20 << 25) | (0X5 << 12) | 0B0110011)
	RPUSH x1
	FC R_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_SRA
	
	DEFW L_OR, "L.OR,"
	LIT ((0x00 << 25) | (0X6 << 12) | 0B0110011)
	RPUSH x1
	FC R_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_OR

	DEFW L_AND, "L.AND,"
	LIT ((0x00 << 25) | (0X7 << 12) | 0B0110011)
	RPUSH x1
	FC R_TYPE
	RPOP x1
	TC LCOMMA
	ENDW L_AND

	DEFW L_FENCE_I, "L.FENCE.I,"
	LIT 0x0000100F
	TC LCOMMA
	ENDW L_FENCE_I

	DEFW L_FENCE_IORW_IORW, "L.FENCE-IORW-IORW,"
	LIT 0x0FF0000F
	TC LCOMMA
	ENDW L_FENCE_IORW_IORW
	
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

	DEFW W_J, "W.J,"
	# ( OFFSET -- )
	LIT 0B1010000000000001
	RPUSH x1
	FC CJ_TYPE
	RPOP x1
	TC WCOMMA
	ENDW W_J

	DEFW W_JAL, "W.JAL,"
	# ( OFFSET -- )
	LIT 0B0010000000000001
	RPUSH x1
	FC CJ_TYPE
	RPOP x1
	TC WCOMMA
	ENDW W_JAL

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

	DEFW W_BEQZ, "W.BEQZ,"
	LIT 0B1100000000000001
	RPUSH x1
	FC CB_TYPE
	RPOP x1
	TC WCOMMA
	ENDW W_BEQZ

	DEFW W_BNEZ, "W.BNEZ,"
	LIT 0B1110000000000001
	RPUSH x1
	FC CB_TYPE
	RPOP x1
	TC WCOMMA
	ENDW W_BNEZ

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

	DEFW W_SUB, "W.SUB,"
	LIT ((0b100 << 13) | (0b11 << 10) | (0b00 << 5) | 0b01)
	RPUSH x1
	FC CA_TYPE
	RPOP x1
	TC WCOMMA
	ENDW W_SUB

	DEFW W_XOR, "W.XOR,"
	LIT ((0b100 << 13) | (0b11 << 10) | (0b01 << 5) | 0b01)
	RPUSH x1
	FC CA_TYPE
	RPOP x1
	TC WCOMMA
	ENDW W_XOR

	DEFW W_OR, "W.OR,"
	LIT ((0b100 << 13) | (0b11 << 10) | (0b10 << 5) | 0b01)
	RPUSH x1
	FC CA_TYPE
	RPOP x1
	TC WCOMMA
	ENDW W_OR

	DEFW W_AND, "W.AND,"
	LIT ((0b100 << 13) | (0b11 << 10) | (0b11 << 5) | 0b01)
	RPUSH x1
	FC CA_TYPE
	RPOP x1
	TC WCOMMA
	ENDW W_AND

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

	DEFW W_SW, "W.SW,"
	LIT 0B1100000000000000
	RPUSH x1
	FC CSW_TYPE
	RPOP x1
	TC WCOMMA
	ENDW W_SW

	DEFW CLW_TYPE, "CLW-TYPE"
	# ( IMM RS1 RD FUNCT3_OPCODE -- WINSTRUCTION )
	TC CSW_TYPE
	ENDW CLW_TYPE

	DEFW DIS_CLW_TYPE, "DIS-CLW-TYPE"
	# ( WINSTRUCTION -- IMM RS1 RD FUNCT3_OPCODE )
	TC DIS_CSW_TYPE
	ENDW DIS_CLW_TYPE

	DEFW W_LW, "W.LW,"
	LIT 0B0100000000000000
	RPUSH x1
	FC CLW_TYPE
	RPOP x1
	TC WCOMMA
	ENDW W_LW

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

	DEFW W_ADDI, "W.ADDI,"
	LIT 0B0000000000000001
	RPUSH x1
	FC CI_TYPE
	RPOP x1
	TC WCOMMA
	ENDW W_ADDI

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

	DEFW W_MV, "W.MV,"
	LIT 0B1000000000000010
	RPUSH x1
	FC CR_TYPE
	RPOP x1
	TC WCOMMA
	ENDW W_MV

	DEFW W_ADD, "W.ADD,"
	LIT 0B1001000000000010
	RPUSH x1
	FC CR_TYPE
	RPOP x1
	TC WCOMMA
	ENDW W_ADD

	DEFW W_JALR, "W.JALR,"
	LIT 0X0
	LIT 0B1001000000000010
	RPUSH x1
	FC CR_TYPE
	RPOP x1
	TC WCOMMA
	ENDW W_JALR

	DEFW W_JR, "W.JR,"
	LIT 0X0
	LIT 0B1000000000000010
	RPUSH x1
	FC CR_TYPE
	RPOP x1
	TC WCOMMA
	ENDW W_JR

	DEFW W_EBREAK, "W.EBREAK,"
	LIT 0X9002
	TC WCOMMA
	ENDW W_EBREAK

	DEFW CALL, "CALL,"
	# ( ADDR -- )
	# L.JALR,          : x0 +/- 2046    x0 +/- ~2KiB
	add x14, x0, 0x7FE
	bgt x15, x14, 1f
	LIT 0X0 0X1
	TC L_JALR
1:
	# W.JAL,           : +/- 2046        +/- ~2KiB
	# L.JAL,           : +/- 1048574     +/- ~1MiB
	# L.AUIPC, L.JALR, : +/- 2147483646  +/- ~2GiB
	la x14, FORTH_DP
	lw x14, 0(x14)
	sub x15, x15, x14
	mv x14, x15
	bgtz x14, 1f
	xori x14, x14, -1
	addi x14, x14, 1
1:
	li x13, 0x7FE
	bgt x14, x13, 1f
	TC W_JAL
1:
	li x13, 0xFFFFE
	bgt x14, x13, 1f
	LIT 0x1
	TC L_JAL
1:
	li x13, 0x7FFFFFFE
	bgt x14, x13, 1f
	# : FAR-CALL, ( ADDR -- ) HERE - DUP $800 + $FFF INVERT AND DUP $1 L.AUIPC, - $1 DUP L.JALR, ;
	RPUSH x1
	FC DUP
	LIT 0X800
	FC PLUS
	LIT 0XFFF
	FC INVERT, AND, DUP
	LIT 0X1
	FC L_AUIPC, MINUS
	LIT 0X1
	FC DUP
	RPOP x1
	TC L_JALR
1:
	j 1b # TODO: PRINT A ERROR THEN CALL ABORT
	ENDW CALL

	DEFW TAIL, "TAIL,"
	# ( ADDR -- )
	# L.JALR,          : x0 +/- 2046    x0 +/- ~2KiB
	add x14, x0, 0x7FE
	bgt x15, x14, 1f
	LIT 0X0 0X0
	TC L_JALR
1:
	# W.J,             : +/- 2046        +/- ~2KiB
	# L.JAL,           : +/- 1048574     +/- ~1MiB
	# L.AUIPC, L.JALR, : +/- 2147483646  +/- ~2GiB
	la x14, FORTH_DP
	lw x14, 0(x14)
	sub x15, x15, x14
	mv x14, x15
	bgtz x14, 1f
	xori x14, x14, -1
	addi x14, x14, 1
1:
	li x13, 0x7FE
	bgt x14, x13, 1f
	TC W_J
1:
	li x13, 0xFFFFE
	bgt x14, x13, 1f
	LIT 0x0
	TC L_JAL
1:
	li x13, 0x7FFFFFFE
	bgt x14, x13, 1f
	# : FAR-TAIL, ( ADDR -- ) HERE - DUP $800 + $FFF INVERT AND DUP $1F L.AUIPC, - $1F $0 L.JALR, ;
	RPUSH x1
	FC DUP
	LIT 0X800
	FC PLUS
	LIT 0XFFF
	FC INVERT, AND, DUP
	LIT 0X1F
	FC L_AUIPC, MINUS
	LIT 0X1F, 0x0
	RPOP x1
	TC L_JALR
1:
	j 1b # TODO: PRINT A ERROR THEN CALL ABORT
	ENDW TAIL

	DEFW SW, "SW,"
	# ( IMM RS2 RS1 -- )
	addi x14, x15, -8
	li x13, 7
	bgtu x14, x13, 1f
	lw x14, 0(x9)
	addi x14, x14, -8
	bgtu x14, x13, 1f
	lw x14, 4(x9)
	andi x13, x14, 0b1111100
	bne x13, x14, 1f
	# ( IMM RS2 RS1 ) -> ( IMM RS1 RS2 )
	mv x14, x15
	lw x15, 0(x9)
	sw x14, 0(x9)
	TC W_SW
1:
	TC L_SW
	ENDW SW

	DEFW LW, "LW,"
	# ( IMM RS1 RD -- )
	addi x14, x15, -8
	li x13, 7
	bgtu x14, x13, 1f
	lw x14, 0(x9)
	addi x14, x14, -8
	bgtu x14, x13, 1f
	lw x14, 4(x9)
	andi x13, x14, 0b1111100
	bne x13, x14, 1f
	TC W_LW
1:
	TC L_LW
	ENDW LW

	DEFW ADDI, "ADDI,"
	# ( IMM RS1 RD -- )
	lw x14, 0(x9)
	bne x14, x15, 1f
	lw x14, 4(x9)
	beqz x14, 1f
	srai x13, x14, 31
	add x14, x14, x13
	xor x14, x14, x13
	andi x13, x14, 0b11111
	bne x13, x14, 1f
	addi x9, x9, 4
	TC W_ADDI
1:
	TC L_ADDI
	ENDW ADDI

	DEFW BEQ, "BEQ,"
	# ( OFFSET RS2 RS1 -- )
	lw x14, 4(x9)
	srai x13, x14, 31
	add x14, x14, x13
	xor x14, x14, x13
	andi x13, x14, 0b11111110
	bne x13, x14, 2f
	lw x14, 0(x9)
	sltiu x13, x15, 1
	sltiu x12, x14, 1
	xor x12, x12, x13
	beqz x12, 2f
	beqz x14, 1f
	mv x15, x14
1:
	addi x14, x15, -8
	sltiu x14, x14, 8
	beqz x14, 2f
	addi x9, x9, 4
	TC W_BEQZ
2:
	TC L_BEQ
	ENDW BEQ
	


	DEFW BNE, "BNE,"
	# ( OFFSET RS2 RS1 -- )
	lw x14, 4(x9)
	srai x13, x14, 31
	add x14, x14, x13
	xor x14, x14, x13
	andi x13, x14, 0b11111110
	bne x13, x14, 2f
	lw x14, 0(x9)
	sltiu x13, x15, 1
	sltiu x12, x14, 1
	xor x12, x12, x13
	beqz x12, 2f
	beqz x14, 1f
	mv x15, x14
1:
	addi x14, x15, -8
	sltiu x14, x14, 8
	beqz x14, 2f
	addi x9, x9, 4
	TC W_BNEZ
2:
	TC L_BNE
	ENDW BNE

	DEFW LI, "LI,"
	# ( VAL RD -- )
	# L.ADDI,          : x0 +2047/-2048
	lw x14, 0(x9)
	li x13, -2048
	slt x12, x14, x13
	li x13, 2047
	slt x11, x13, x14
	or x12, x11, x12
	bnez x12, 1f
	PPUSH x0
	TC L_ADDI
1:
	# L.LUI, L.ADDI,  : x0 >= +2048/<= -2049
	# : HUGE-LI, ( VAL RD ) OVER $800 + $FFF INVERT AND DUP >R OVER LUI, R> ROT SWAP - SWAP DUP ADDI, ;
	RPUSH x1
	FC OVER
	LIT 0X800
	FC PLUS
	LIT 0XFFF
	FC INVERT, AND, DUP, TOR, OVER, L_LUI
	FC FROMR, ROT, SWAP, MINUS, SWAP, DUP
	RPOP x1
	TC L_ADDI
	ENDW LI
