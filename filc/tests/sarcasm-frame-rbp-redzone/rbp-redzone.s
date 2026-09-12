	.file	"rbp-redzone.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(long, long)
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	addq	-16(%rbp), %rax
	popq	%rbp
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
