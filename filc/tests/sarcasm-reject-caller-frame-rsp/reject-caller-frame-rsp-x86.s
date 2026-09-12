	.file	"caller-frame-rsp.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long()
	subq	$16, %rsp
	movq	64(%rsp), %rax
	addq	$16, %rsp
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
