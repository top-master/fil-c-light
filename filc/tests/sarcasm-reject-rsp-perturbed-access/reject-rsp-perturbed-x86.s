	.file	"rsp-perturbed-access.c"
	.text
	.p2align 4
	.globl	work
	.type	work, @function
work:                           ;! ptr(long)
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, %rax      ;! alloca size (p)
	movq	%rax, -24(%rbp)
	leaq	23(%rax), %rcx
	andq	$-16, %rcx
	subq	%rcx, %rsp
	leaq	15(%rsp), %rdx
	movq	%rdx, %rdi
	andq	$-16, %rdi      ;! alloca result (p)
	movq	%rdi, -16(%rbp)
	movq	-8(%rsp), %rax      # rsp-relative frame access while the alloca perturbed %rsp
	movq	-16(%rbp), %rax
	leaq	-8(%rbp), %rsp
	popq	%rbx
	popq	%rbp
	ret
	.size	work, .-work
	.section	.note.GNU-stack,"",@progbits
