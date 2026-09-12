# `.quad some_label` in a data block is a pointer initializer needing a
# constant relocation — a clean compile-time rejection in v1 (the block is
# live: the function references the label).
	.text
	.globl	f
	.type	f, @function
f:                              ;! long()
	leaq	tab(%rip), %rax
	movq	(%rax), %rax
	ret
	.size	f, .-f
	.section	.rodata
	.p2align	4
tab:
	.quad	tab
	.section	.note.GNU-stack,"",@progbits
