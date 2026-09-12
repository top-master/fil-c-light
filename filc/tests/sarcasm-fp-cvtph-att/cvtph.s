	.text
	.globl	ps2ph
	.type	ps2ph, @function
ps2ph:                          ;! void(ptr, ptr)
	# vcvtps2ph ymm -> m128: the memory destination is exactly 16 bytes (8
	# half-floats). The buffer is 16 bytes; the old width-doubling logic
	# would have checked 32/64 bytes and spuriously trapped.
	vmovups	(%rdi), %ymm0
	vcvtps2ph	$0, %ymm0, (%rsi)
	ret
	.size	ps2ph, .-ps2ph
	.globl	ph2ps
	.type	ph2ps, @function
ph2ps:                          ;! void(ptr, ptr)
	# vcvtph2ps m128 -> ymm: exactly a 16-byte load.
	vcvtph2ps	(%rdi), %ymm0
	vmovups	%ymm0, (%rsi)
	ret
	.size	ph2ps, .-ph2ps
	.section	.note.GNU-stack,"",@progbits
