	.file	"addmul.c"
	.text
	.globl	addmul
	.type	addmul, @function
addmul:                         ;! long(long, long, long)
	movq	%rdi, %rax
	imulq	%rsi, %rax
	addq	%rdx, %rax
	ret
	.size	addmul, .-addmul
	.section	.note.GNU-stack,"",@progbits
