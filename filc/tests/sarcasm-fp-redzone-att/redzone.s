	.text
	.globl	f_redzone
	.type	f_redzone, @function
f_redzone:                      ;! long(long)
	cvtsi2sdq	%rdi, %xmm0
	movsd	%xmm0, -8(%rsp)
	movsd	-8(%rsp), %xmm1
	addsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	ret
	.size	f_redzone, .-f_redzone
	.globl	g_redzone
	.type	g_redzone, @function
g_redzone:                      ;! long(long)
	movq	%rdi, %xmm2
	movups	%xmm2, -32(%rsp)
	movups	-32(%rsp), %xmm3
	movq	%xmm3, %rax
	addq	%rdi, %rax
	ret
	.size	g_redzone, .-g_redzone
	.section	.note.GNU-stack,"",@progbits
