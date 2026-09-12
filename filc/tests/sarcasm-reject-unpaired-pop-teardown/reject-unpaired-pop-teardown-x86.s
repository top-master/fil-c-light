	.file	"unpaired-pop-teardown.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	addq	$16, %rsp
	popq	%rbx
	movq	%rbx, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
