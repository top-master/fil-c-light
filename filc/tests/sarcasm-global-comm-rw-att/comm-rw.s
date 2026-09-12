	.text
	.globl	g_store
	.type	g_store, @function
g_store:                        ;! void(long)
	movl	%edi, g(%rip)
	movl	%edi, g+4(%rip)
	movl	%edi, g+8(%rip)
	movl	%edi, g+12(%rip)
	ret
	.size	g_store, .-g_store
	.globl	g_load
	.type	g_load, @function
g_load:                         ;! long(long)
	leaq	g(%rip), %rax
	movl	(%rax,%rdi,4), %eax
	ret
	.size	g_load, .-g_load
	.comm	g,16,16
	.section	.note.GNU-stack,"",@progbits
