	.text
	.globl	pminsd_oob
	.type	pminsd_oob, @function
pminsd_oob:                     ;! void(ptr, ptr)
	# pminsd (SSE spelling, two-operand xmm form) reads a full 16-byte
	# m128. The ss/sd scalar suffix rule used to under-check p-stem
	# mnemonics at 8 bytes (proving the SSE p-stem side of the fix, not
	# just the AVX512 side). rsi points 8 bytes before the end of a
	# 64-byte object: the 8-byte check would pass, the 16-byte check traps.
	pminsd	(%rsi), %xmm0
	ret
	.size	pminsd_oob, .-pminsd_oob
	.section	.note.GNU-stack,"",@progbits
