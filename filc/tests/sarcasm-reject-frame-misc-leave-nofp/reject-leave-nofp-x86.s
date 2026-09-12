	.file	"leave-nofp.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(long)
	subq	$16, %rsp
	movq	%rdi, (%rsp)
	movq	(%rsp), %rax
	leave
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
