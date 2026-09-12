	.file	"alloca_earlyexit.c"
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	endbr64
	testl	%edi, %edi
	je	.Lzero
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	leave
	ret
.Lzero:
	xorl	%eax, %eax
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
