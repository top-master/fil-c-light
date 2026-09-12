	.file	"combine.c"
	.text
	.globl	sumsq
	.type	sumsq, @function
sumsq:                          ;! long(long, long)
	pushq	%rbx
	pushq	%r12
	movq	%rdi, %rbx
	movq	%rsi, %r12
	call	square          ;! long(long)
	movq	%rax, %rbx
	movq	%r12, %rdi
	call	square          ;! long(long)
	addq	%rbx, %rax
	popq	%r12
	popq	%rbx
	ret
	.size	sumsq, .-sumsq
	.section	.note.GNU-stack,"",@progbits
