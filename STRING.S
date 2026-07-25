	DEFW MEMCMP, "MEMCMP"
	# ( C-ADDR1 C-ADDR2 COUNT -- N )
	# If count is zero, n is zero.
	# If count is greater than zero, compare the two strings 
	# character by character, up to count characters. If the two 
	# strings are identical up to count characters, n is zero.
	# If the two strings are not identical up to count characters,
	# n is minus-one (-1) if the first non-matching character in
	# the string specified by c-addr1 has a lesser numeric value
	# than the corresponding character in the string specified by
	# c-addr2 and one (1) otherwise
	# Unlike COMPARE, MEMCMP does not operate on strings of
	# differing lengths; count specifies the exact number of
	# characters to be compared, and no length comparison is
	# performed if the two strings are identical up to count
	# characters.
	mv x14, x15
	lw x13, 0(x9)
	lw x12, 4(x9)
	addi x9, x9, 8
	bnez x14, 1f
	li x15, 0
	ret
1:
	lbu x10, 0(x12)
	lbu x11, 0(x13)
	sub x15, x10, x11
	beqz x15, 2f
	bltz x15, 3f
	li x15, 1
	ret
3:
	li x15, -1
	ret
2:
	addi x12, x12, 1
	addi x13, x13, 1
	addi x14, x14, -1
	bnez x14, 1b
	ret
	ENDW MEMCMP

	DEFW ISNUMBER, "NUMBER?"
	# ( C-ADDR COUNT -- FLAG )
	mv x14, x15
	lw x13, 0(x9)
	addi x9, x9, 4
	li x15, 0
	li x12, 1
	bgt x14, x12, 1f
	ret
1:
	lbu x12, 0(x13)
	li x11, '$'
	beq x11, x12, 1f
	ret
1:
	addi x13, x13, 1
	addi x14, x14, -1
1:
	lbu x12, 0(x13)
	li x11, '0'
	bge x12, x11, 2f
	ret
2:
	li x11, 'F'
	ble x12, x11, 2f
	ret
2:
	li x11, '9'
	ble x12, x11, 2f
	li x11, 'A'
	bge x12, x11, 2f
	ret
2:
	addi x13, x13, 1
	addi x14, x14, -1
	bgtz x14, 1b

	li x15, -1
	ret
	ENDW ISNUMBER

	DEFW TONUMBER, ">NUMBER"
	# ( C-ADDR COUNT -- NUMBER )
	mv x14, x15
	lw x13, 0(x9)
	addi x9, x9, 4
	li x15, 0
	li x12, 0x9
	ble x14, x12, 1f
	ret
1:
	li x12, 1
	bgt x14, x12, 1f
	ret
1:
	addi x13, x13, 1
	addi x14, x14, -1
1:
	lbu x12, 0(x13)
	li x11, '9'
	bgt x12, x11, 2f
	addi x12, x12, -0x30
	j 3f
2:
	addi x12, x12, -0x37
3:
	addi x11, x14, -1
	slli x11, x11, 2
	sll x12, x12, x11
	or x15, x15, x12
	addi x14, x14, -1
	addi x13, x13, 1
	bnez x14, 1b
	ret
	ENDW TONUMBER
