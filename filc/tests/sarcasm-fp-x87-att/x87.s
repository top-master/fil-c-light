	.text
	.globl	x87_mem
	.type	x87_mem, @function
x87_mem:                        ;! long(ptr)
	fldl	(%rdi)
	faddl	8(%rdi)
	fstpl	16(%rdi)
	fildl	24(%rdi)
	fistpq	32(%rdi)
	movq	32(%rdi), %rax
	ret
	.size	x87_mem, .-x87_mem
	.globl	x87_stack
	.type	x87_stack, @function
x87_stack:                      ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	cvtsi2sdq	%rdi, %xmm0
	movsd	%xmm0, -8(%rbp)
	fldl	-8(%rbp)
	fld1
	faddp	%st, %st(1)
	fistpq	-8(%rbp)
	movq	-8(%rbp), %rcx
	cvtsi2sdq	%rcx, %xmm1
	movsd	%xmm1, -16(%rbp)
	fldl	-16(%rbp)
	fstpt	-32(%rbp)
	fldt	-32(%rbp)
	fstpl	-40(%rbp)
	movsd	-40(%rbp), %xmm2
	cvttsd2siq	%xmm2, %rdx
	leaq	(%rcx,%rdx), %rax
	leave
	ret
	.size	x87_stack, .-x87_stack
	.section	.note.GNU-stack,"",@progbits
