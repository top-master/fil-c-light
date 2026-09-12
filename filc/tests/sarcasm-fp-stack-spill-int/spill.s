	.intel_syntax noprefix
	.text
	.globl	f_spill
	.type	f_spill, @function
f_spill:                        ;! long(long, long)
	sub	rsp, 40
	cvtsi2sd	xmm0, rdi
	cvtsi2sd	xmm1, rsi
	movsd	QWORD PTR [rsp+8], xmm0
	movdqa	XMMWORD PTR [rsp+16], xmm1
	movsd	xmm2, QWORD PTR [rsp+8]
	movdqa	xmm3, XMMWORD PTR [rsp+16]
	addsd	xmm2, xmm3
	mulsd	xmm2, xmm2
	cvttsd2si	rax, xmm2
	add	rsp, 40
	ret
	.size	f_spill, .-f_spill
	.section	.note.GNU-stack,"",@progbits
