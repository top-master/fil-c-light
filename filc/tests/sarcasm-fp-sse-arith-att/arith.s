	.text
	.globl	f_arith
	.type	f_arith, @function
f_arith:                        ;! long(long, long)
	cvtsi2sdq	%rdi, %xmm0
	cvtsi2sdq	%rsi, %xmm1
	movsd	%xmm0, %xmm2
	addsd	%xmm1, %xmm2
	movsd	%xmm0, %xmm3
	subsd	%xmm1, %xmm3
	movsd	%xmm0, %xmm4
	mulsd	%xmm1, %xmm4
	movsd	%xmm0, %xmm5
	divsd	%xmm1, %xmm5
	sqrtsd	%xmm4, %xmm6
	movsd	%xmm2, %xmm7
	minsd	%xmm4, %xmm7
	movsd	%xmm3, %xmm8
	maxsd	%xmm5, %xmm8
	xorl	%eax, %eax
	comisd	%xmm4, %xmm2
	setb	%al
	xorl	%r8d, %r8d
	ucomisd	%xmm3, %xmm0
	seta	%r8b
	cvttsd2siq	%xmm2, %rcx
	cvttsd2siq	%xmm3, %rdx
	addq	%rdx, %rcx
	cvttsd2siq	%xmm4, %rdx
	addq	%rdx, %rcx
	cvttsd2siq	%xmm5, %rdx
	addq	%rdx, %rcx
	cvttsd2siq	%xmm6, %rdx
	addq	%rdx, %rcx
	cvttsd2siq	%xmm7, %rdx
	addq	%rdx, %rcx
	cvttsd2siq	%xmm8, %rdx
	addq	%rdx, %rcx
	addq	%rax, %rcx
	addq	%r8, %rcx
	addq	%rdi, %rcx
	movq	%rcx, %rax
	ret
	.size	f_arith, .-f_arith
	.section	.note.GNU-stack,"",@progbits
