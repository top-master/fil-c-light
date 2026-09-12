	.text
	.globl	fx_rt
	.type	fx_rt, @function
fx_rt:                          ;! long(ptr, long)
	cvtsi2sdq	%rsi, %xmm0
	cvtsi2sdq	%rsi, %xmm7
	fxsave	(%rdi)
	pxor	%xmm0, %xmm0
	pxor	%xmm7, %xmm7
	fxrstor	(%rdi)
	cvttsd2siq	%xmm0, %rax
	cvttsd2siq	%xmm7, %rcx
	addq	%rcx, %rax
	ret
	.size	fx_rt, .-fx_rt
	.globl	mxcsr_rt
	.type	mxcsr_rt, @function
mxcsr_rt:                       ;! long(ptr, long)
	stmxcsr	(%rdi)
	movl	%esi, 4(%rdi)
	ldmxcsr	4(%rdi)
	stmxcsr	8(%rdi)
	movl	8(%rdi), %eax
	ret
	.size	mxcsr_rt, .-mxcsr_rt
	.section	.note.GNU-stack,"",@progbits
