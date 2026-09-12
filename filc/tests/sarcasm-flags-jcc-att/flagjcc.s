	.text
	.globl	flagjcc
	.type	flagjcc, @function
flagjcc:                        ;! long(ptr, long)
	cmpq	$5, %rsi
	movq	(%rdi), %rax
	jg	.Lbig
	movl	$0, %eax
	ret
.Lbig:
	movl	$1, %eax
	ret
	.size	flagjcc, .-flagjcc
	.section	.note.GNU-stack,"",@progbits
