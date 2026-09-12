	.file	"spill.c"
	.text
	.globl	sumn
	.type	sumn, @function
sumn:                           ;! unsigned(ptr)
	movq	(%rdi), %rax
	movq	8(%rdi), %rcx
	movq	16(%rdi), %rdx
	movq	24(%rdi), %rbx
	movq	32(%rdi), %rbp
	movq	40(%rdi), %rsi
	movq	48(%rdi), %r8
	movq	56(%rdi), %r9
	movq	64(%rdi), %r10
	movq	72(%rdi), %r12
	movq	80(%rdi), %r13
	movq	88(%rdi), %r14
	movq	96(%rdi), %r15
	addq	%rcx, %rax
	addq	%rdx, %rax
	addq	%rbx, %rax
	addq	%rbp, %rax
	addq	%rsi, %rax
	addq	%r8, %rax
	addq	%r9, %rax
	addq	%r10, %rax
	addq	%r12, %rax
	addq	%r13, %rax
	addq	%r14, %rax
	addq	%r15, %rax
	ret
	.size	sumn, .-sumn
	.section	.note.GNU-stack,"",@progbits
