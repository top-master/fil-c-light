	.text
	.globl	flaglahf
	.type	flaglahf, @function
flaglahf:                       ;! long(ptr)
	stc
	movq	(%rdi), %rcx
	lahf
	shrq	$8, %rax
	andq	$1, %rax
	ret
	.size	flaglahf, .-flaglahf
	.section	.note.GNU-stack,"",@progbits
