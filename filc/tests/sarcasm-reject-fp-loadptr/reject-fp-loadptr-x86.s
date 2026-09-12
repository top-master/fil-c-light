	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	movsd	(%rdi), %xmm0     ;! load ptr
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
