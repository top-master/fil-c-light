	.file	"mid-fp.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(long)
	subq	$16, %rsp
	movq	%rdi, (%rsp)
	movq	%rsp, %rbp
	movq	(%rsp), %rax
	addq	$16, %rsp
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
