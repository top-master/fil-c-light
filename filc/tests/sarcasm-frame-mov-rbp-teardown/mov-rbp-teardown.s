	.file	"mov-rbp-teardown.c"
	.text
	.globl	foo_movrbp
	.type	foo_movrbp, @function
foo_movrbp:                     ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	8(%rsp), %rax
	addq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	ret
	.size	foo_movrbp, .-foo_movrbp
	.globl	foo_nolocals
	.type	foo_nolocals, @function
foo_nolocals:                   ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, %rax
	addq	$3, %rax
	movq	%rbp, %rsp
	popq	%rbp
	ret
	.size	foo_nolocals, .-foo_nolocals
	.section	.note.GNU-stack,"",@progbits
