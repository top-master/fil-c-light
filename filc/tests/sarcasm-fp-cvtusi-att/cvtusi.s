	.text
	.globl	cvt_ss
	.type	cvt_ss, @function
cvt_ss:                         ;! void(ptr)
	# Stale-register regression: vcvtusi2ss must read the POST-imul eax (42),
	# not a stale pre-imul value (6) — the GPR integer source is a modeled use.
	movl	$6, %eax
	imull	$7, %eax, %eax
	vcvtusi2ss	%eax, %xmm0, %xmm1
	movss	%xmm1, (%rdi)
	ret
	.size	cvt_ss, .-cvt_ss
	.globl	cvt_sd
	.type	cvt_sd, @function
cvt_sd:                         ;! void(ptr)
	# q form: 64-bit GPR integer source.
	movabsq	$123456789, %rax
	imulq	$97, %rax, %rax
	vcvtusi2sd	%rax, %xmm1, %xmm2
	movsd	%xmm2, (%rdi)
	ret
	.size	cvt_sd, .-cvt_sd
	.globl	cvt_back_d
	.type	cvt_back_d, @function
cvt_back_d:                     ;! long(ptr)
	# Reverse direction: the GPR destination of vcvttsd2usi is a modeled def;
	# the result must survive into subsequent integer arithmetic.
	movsd	(%rdi), %xmm3
	vcvttsd2usi	%xmm3, %rax
	addq	$7, %rax
	ret
	.size	cvt_back_d, .-cvt_back_d
	.globl	cvt_back_s
	.type	cvt_back_s, @function
cvt_back_s:                     ;! long(ptr)
	movss	(%rdi), %xmm4
	vcvttss2usi	%xmm4, %eax
	addl	$1, %eax
	ret
	.size	cvt_back_s, .-cvt_back_s
	.section	.note.GNU-stack,"",@progbits
