	.file	"rbp-escape-pair.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	pushq	%rbp
	popq	%rbx
	movq	%rbx, %rax
	leave
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
