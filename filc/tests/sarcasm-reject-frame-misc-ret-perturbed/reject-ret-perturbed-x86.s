	.file	"ret-perturbed.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long()
	subq	$16, %rsp
	movq	$5, (%rsp)
	movq	(%rsp), %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
