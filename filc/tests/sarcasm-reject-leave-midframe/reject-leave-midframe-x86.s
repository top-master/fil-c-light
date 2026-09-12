	.file	"leave-midframe.c"
	.text
	.globl	leaveread
	.type	leaveread, @function
leaveread:                      ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rcx
	leave
	movq	-8(%rbp), %rdi
	movq	%rdi, %rax
	ret
	.size	leaveread, .-leaveread
	.section	.note.GNU-stack,"",@progbits
