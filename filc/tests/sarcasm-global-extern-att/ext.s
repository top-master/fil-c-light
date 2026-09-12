	.text
	.globl	ext_lea
	.type	ext_lea, @function
ext_lea:                        ;! long(long)
	leaq	g(%rip), %rax #! global ptr
	movl	(%rax,%rdi,4), %eax
	ret
	.size	ext_lea, .-ext_lea
	.globl	ext_direct
	.type	ext_direct, @function
ext_direct:                     ;! long()
	movl	g+8(%rip), %eax #! global ptr
	addl	g+12(%rip), %eax #! global ptr
	ret
	.size	ext_direct, .-ext_direct
	.globl	ext_store
	.type	ext_store, @function
ext_store:                      ;! void(long,long)
	leaq	g(%rip), %rax #! global ptr
	movl	%esi, (%rax,%rdi,4)
	ret
	.size	ext_store, .-ext_store
	.section	.note.GNU-stack,"",@progbits
