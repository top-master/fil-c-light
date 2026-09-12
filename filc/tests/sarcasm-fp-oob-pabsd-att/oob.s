	.text
	.globl	pabsd_oob
	.type	pabsd_oob, @function
pabsd_oob:                      ;! void(ptr, ptr)
	# vpabsd reads a FULL 64-byte vector from memory. The ss/sd scalar
	# suffix rule used to under-check p-stem mnemonics (the trailing "sd"
	# is part of the NAME, not a scalar suffix) at 8 bytes. rsi points 8
	# bytes before the end of a 64-byte object: the 8-byte check would
	# pass, the 64-byte check traps.
	vpabsd	(%rsi), %zmm0
	ret
	.size	pabsd_oob, .-pabsd_oob
	.section	.note.GNU-stack,"",@progbits
