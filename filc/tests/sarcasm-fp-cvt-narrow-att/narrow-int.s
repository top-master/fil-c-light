	.intel_syntax noprefix
	.text
	.globl	cvt_narrow_xmm_int
	.type	cvt_narrow_xmm_int, @function
cvt_narrow_xmm_int:             ;! void(ptr, ptr)
	# vcvtpd2ps xmm0, XMMWORD PTR [rdi]: the Intel PTR size drives an exact
	# 16-byte width (rendered with a synthesized source suffix). rdi ->
	# 16-byte object holding two doubles (the 16-byte checked load fills the
	# object exactly); rsi -> float[4] out.
	vcvtpd2ps	xmm0, XMMWORD PTR [rdi]
	vmovups	XMMWORD PTR [rsi], xmm0
	ret
	.size	cvt_narrow_xmm_int, .-cvt_narrow_xmm_int
	.section	.note.GNU-stack,"",@progbits
