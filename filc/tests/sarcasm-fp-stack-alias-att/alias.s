	.text
	.globl	f_alias
	.type	f_alias, @function
f_alias:                        ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movsd	-8(%rbp), %xmm0
	addsd	%xmm0, %xmm0
	cvttsd2siq	%xmm0, %rax
	leave
	ret
	.size	f_alias, .-f_alias
	.globl	g_alias
	.type	g_alias, @function
g_alias:                        ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, %xmm0
	movaps	%xmm0, -32(%rbp)
	movq	%rdi, -24(%rbp)
	movsd	-32(%rbp), %xmm1
	movsd	-24(%rbp), %xmm2
	addsd	%xmm2, %xmm1
	cvttsd2siq	%xmm1, %rax
	leave
	ret
	.size	g_alias, .-g_alias
	.section	.note.GNU-stack,"",@progbits
