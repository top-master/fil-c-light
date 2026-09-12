	.text
	.globl	bf16cvt
	.type	bf16cvt, @function
bf16cvt:                        ;! void(ptr, ptr)
	# vcvtneps2bf16 ymm, m512: narrowing convert, memory source is 2x the
	# destination = 64 bytes (floats at [0,64) of in).
	vcvtneps2bf16	(%rdi), %ymm0
	vmovdqu32	%ymm0, (%rsi)
	# vcvtne2ps2bf16 zmm, zmm, m512: two full-width sources; the memory
	# operand (floats at [128,192)) gets the full-width 64-byte check ending
	# exactly at the end of the allocation. Destination low half = memory
	# source, high half = register source (verified against the ISA).
	vmovups	64(%rdi), %zmm1
	vcvtne2ps2bf16	128(%rdi), %zmm1, %zmm2
	vmovdqu64	%zmm2, 32(%rsi)
	ret
	.size	bf16cvt, .-bf16cvt
	.section	.note.GNU-stack,"",@progbits
