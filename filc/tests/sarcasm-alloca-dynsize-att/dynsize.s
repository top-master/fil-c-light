	.file	"dynsize.c"
	.text
	.p2align 4
	.globl	work
	.type	work, @function
work:                           ;! ptr(long)
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$40, %rsp
	movq	%rdi, %rax      ;! alloca size (ptr)
	movq	%rax, -64(%rbp)
	leaq	23(%rax), %rcx
	andq	$-16, %rcx
	subq	%rcx, %rsp
	leaq	15(%rsp), %rdx
	movq	%rdx, %rdi
	andq	$-16, %rdi      ;! alloca result (ptr)
	movq	%rdi, -56(%rbp)
	movq	-64(%rbp), %rsi
	xorl	%ecx, %ecx
	testq	%rsi, %rsi
	jle	.Ldone
.Lfill:
	movq	-56(%rbp), %rdx
	movb	%cl, (%rdx,%rcx)
	incq	%rcx
	cmpq	%rcx, %rsi
	jne	.Lfill
.Ldone:
	movq	-56(%rbp), %rax
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.size	work, .-work
	.section	.note.GNU-stack,"",@progbits
