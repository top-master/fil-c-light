	.file	"caller-frame-load.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long()
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	16(%rbp), %rax
	leave
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
