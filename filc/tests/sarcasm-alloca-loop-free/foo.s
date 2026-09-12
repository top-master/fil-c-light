	.file	"alloca_loop_free.c"
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! void(int, int)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$40, %rsp
	movl	%esi, -8(%rbp)
	movl	%edi, -12(%rbp)
.L1:
	movl	-12(%rbp), %eax
	testl	%eax, %eax
	je	.L2
	movl	-8(%rbp), %eax
	movslq	%eax, %rsi
	leaq	23(%rsi), %rax
	andq	$-16, %rax          ;! alloca size (buf)
	subq	%rax, %rsp
	leaq	15(%rsp), %rax
	andq	$-16, %rax          ;! alloca result (buf)
	movq	%rax, -16(%rbp)
	movb	$7, (%rax)
	leaq	-40(%rbp), %rsp
	decl	-12(%rbp)
	jne	.L1
.L2:
	leave
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
