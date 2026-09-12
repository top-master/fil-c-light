	.text
	.globl	ps2ph512
	.type	ps2ph512, @function
ps2ph512:                       ;! void(ptr, ptr)
	# EVEX vcvtps2ph zmm -> m256: exactly a 32-byte store (16 half-floats).
	vmovups	(%rdi), %zmm0
	vcvtps2ph	$0, %zmm0, (%rsi)
	ret
	.size	ps2ph512, .-ps2ph512
	.globl	ph2ps512
	.type	ph2ps512, @function
ph2ps512:                       ;! void(ptr, ptr)
	# EVEX vcvtph2ps m256 -> zmm: exactly a 32-byte load.
	vcvtph2ps	(%rdi), %zmm0
	vmovups	%zmm0, (%rsi)
	ret
	.size	ph2ps512, .-ph2ps512
	.section	.note.GNU-stack,"",@progbits
