	.file	"caller-frame-store.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long()
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	$5, 16(%rbp)
	movq	$0, %rax
	leave
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
