	.text
	.globl	ktab_get
	.type	ktab_get, @function
ktab_get:                       ;! long(long)
	leaq	ktab(%rip), %rax
	movl	(%rax,%rdi,4), %eax
	ret
	.size	ktab_get, .-ktab_get
	.section	.rodata
	.p2align	4
ktab:
	.long	1, 2, 3, 4
	.section	.note.GNU-stack,"",@progbits
