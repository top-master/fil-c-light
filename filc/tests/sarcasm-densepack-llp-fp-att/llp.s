	.file	"llp.c"
	.text
	.globl	llp
	.type	llp, @function
llp:                            ;! long(long, long, ptr)
	movq	(%rdx), %rax
	addq	%rdi, %rax
	addq	%rsi, %rax
	ret
	.size	llp, .-llp
	.section	.note.GNU-stack,"",@progbits
