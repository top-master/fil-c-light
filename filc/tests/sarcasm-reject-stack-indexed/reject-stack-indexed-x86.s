	.file	"stack-indexed.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(long)
	subq	$16, %rsp
	movq	(%rsp,%rdi,1), %rax
	addq	$16, %rsp
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
