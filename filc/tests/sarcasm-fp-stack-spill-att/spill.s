	.text
	.globl	f_spill
	.type	f_spill, @function
f_spill:                        ;! long(long, long)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	cvtsi2sdq	%rdi, %xmm0
	cvtsi2sdq	%rsi, %xmm1
	movsd	%xmm0, -8(%rbp)
	movaps	%xmm1, -32(%rbp)
	movsd	-8(%rbp), %xmm2
	movaps	-32(%rbp), %xmm3
	addsd	%xmm3, %xmm2
	mulsd	%xmm2, %xmm2
	cvttsd2siq	%xmm2, %rax
	leave
	ret
	.size	f_spill, .-f_spill
	.section	.note.GNU-stack,"",@progbits
