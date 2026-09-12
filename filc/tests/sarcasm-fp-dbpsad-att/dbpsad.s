	.text
	.globl	dbpsad
	.type	dbpsad, @function
dbpsad:                         ;! void(ptr, ptr)
	# vdbpsadbw zmm, zmm, m512, imm8: full-width 64-byte memory source.
	# in = 128 bytes: src1 at [0,64), the memory operand at [64,128) ending
	# exactly at the end of the allocation.
	vmovdqu64	(%rdi), %zmm0
	vdbpsadbw	$0x1b, 64(%rdi), %zmm0, %zmm1
	vmovdqu64	%zmm1, (%rsi)
	vdbpsadbw	$0xe4, 64(%rdi), %zmm0, %zmm2
	vmovdqu64	%zmm2, 64(%rsi)
	ret
	.size	dbpsad, .-dbpsad
	.section	.note.GNU-stack,"",@progbits
