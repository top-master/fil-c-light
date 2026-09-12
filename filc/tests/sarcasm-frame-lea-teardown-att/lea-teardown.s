	.file	"lea-teardown.c"
	.text
	.p2align 4
	.globl	lea1
	.type	lea1, @function
lea1:                           ;! long(long)
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, -16(%rbp)
	movl	$7, -32(%rbp)
	movq	-16(%rbp), %rax
	leaq	(%rax,%rax,2), %rax
	movslq	-32(%rbp), %rcx
	addq	%rcx, %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	leaq	-8(%rbp), %rsp
	popq	%rbx
	popq	%rbp
	ret
	.size	lea1, .-lea1
	.globl	lea2
	.type	lea2, @function
lea2:                           ;! long(long)
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	pushq	%r12
	pushq	%r13
	subq	$56, %rsp
	movq	%rdi, -32(%rbp)
	movq	-32(%rbp), %rax
	leaq	(%rax,%rax,4), %rax
	movl	$9, -44(%rbp)
	movslq	-44(%rbp), %rcx
	addq	%rcx, %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	leaq	-24(%rbp), %rsp
	popq	%r13
	popq	%r12
	popq	%rbx
	popq	%rbp
	ret
	.size	lea2, .-lea2
	.section	.note.GNU-stack,"",@progbits
