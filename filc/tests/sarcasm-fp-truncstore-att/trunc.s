	.text
	.globl	ts_qb
	.type	ts_qb, @function
ts_qb:                          ;! void(ptr, ptr)
	# vpmovqb stores 8 bytes (one per qword lane); the buffer is 64 bytes, so
	# the store at offset 56 ends exactly at the object end. A full-width
	# (64-byte) check would spuriously trap; the exact 8-byte check passes.
	vmovdqu64	(%rsi), %zmm0
	vpmovqb	%zmm0, 56(%rdi)
	ret
	.size	ts_qb, .-ts_qb
	.globl	ts_usqb
	.type	ts_usqb, @function
ts_usqb:                        ;! void(ptr, ptr)
	vmovdqu64	(%rsi), %zmm0
	vpmovusqb	%zmm0, 56(%rdi)
	ret
	.size	ts_usqb, .-ts_usqb
	.globl	ts_sqb
	.type	ts_sqb, @function
ts_sqb:                         ;! void(ptr, ptr)
	vmovdqu64	(%rsi), %zmm0
	vpmovsqb	%zmm0, 56(%rdi)
	ret
	.size	ts_sqb, .-ts_sqb
	.globl	ts_dw
	.type	ts_dw, @function
ts_dw:                          ;! void(ptr, ptr)
	# vpmovdw ymm: 8 dwords -> 8 words = 16-byte store ending at the object end.
	vmovdqu32	(%rsi), %ymm0
	vpmovdw	%ymm0, 48(%rdi)
	ret
	.size	ts_dw, .-ts_dw
	.globl	ts_wb
	.type	ts_wb, @function
ts_wb:                          ;! void(ptr, ptr)
	# vpmovwb zmm: 32 words -> 32 bytes = 32-byte store ending at the object end.
	vmovdqu16	(%rsi), %zmm0
	vpmovwb	%zmm0, 32(%rdi)
	ret
	.size	ts_wb, .-ts_wb
	.section	.note.GNU-stack,"",@progbits
