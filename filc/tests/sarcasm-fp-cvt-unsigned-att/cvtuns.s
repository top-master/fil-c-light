	.text
	.globl	cvt_ps2uqq
	.type	cvt_ps2uqq, @function
cvt_ps2uqq:                     ;! void(ptr, ptr)
	# vcvtps2uqq zmm, m256: widening convert, memory source is dest/2 = 32
	# bytes (a full-width 64-byte over-check would trap on a 32-byte object).
	vcvtps2uqq	(%rdi), %zmm0
	vmovdqu64	%zmm0, (%rsi)
	ret
	.size	cvt_ps2uqq, .-cvt_ps2uqq
	.globl	cvt_tps2udq
	.type	cvt_tps2udq, @function
cvt_tps2udq:                    ;! void(ptr, ptr)
	# vcvttps2udq zmm, m512: full-width 64-byte source, truncation form.
	vcvttps2udq	(%rdi), %zmm1
	vmovdqu32	%zmm1, (%rsi)
	ret
	.size	cvt_tps2udq, .-cvt_tps2udq
	.globl	cvt_pd2udq
	.type	cvt_pd2udq, @function
cvt_pd2udq:                     ;! void(ptr, ptr)
	# vcvtpd2udq ymm, m512: narrowing convert, memory source is 2x the
	# destination = 64 bytes (an under-check at the 32-byte dest width would
	# miss OOB; this proves the 64-byte source is accepted and read).
	vcvtpd2udq	(%rdi), %ymm2
	vmovdqu32	%ymm2, (%rsi)
	ret
	.size	cvt_pd2udq, .-cvt_pd2udq
	.section	.note.GNU-stack,"",@progbits
