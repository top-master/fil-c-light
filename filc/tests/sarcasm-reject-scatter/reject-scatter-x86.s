	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	vscatterdps	%zmm0, (%rdi,%zmm1,4)
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
