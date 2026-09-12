	.file	"rbp-escape-index.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	(%rdi,%rbp,1), %rax
	leave
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
