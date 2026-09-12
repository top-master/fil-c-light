	.text
	.globl	flagadc
	.type	flagadc, @function
flagadc:                        ;! long(ptr, long)
	movq	%rsi, %rax
	stc
	adcq	(%rdi), %rax
	ret
	.size	flagadc, .-flagadc
	.section	.note.GNU-stack,"",@progbits
