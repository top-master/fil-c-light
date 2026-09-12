	.text
	.globl	c_read
	.type	c_read, @function
c_read:                         ;! long(long)
	leaq	g(%rip), %rax
	movl	(%rax,%rdi,4), %eax
	ret
	.size	c_read, .-c_read
	.comm	g,16,16
	.section	.note.GNU-stack,"",@progbits
