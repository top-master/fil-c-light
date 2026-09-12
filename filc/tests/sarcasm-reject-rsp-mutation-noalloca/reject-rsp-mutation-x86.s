	.file	"rsp-mutation-noalloca.c"
	.text
	.p2align 4
	.globl	f
	.type	f, @function
f:                              ;! long(long)
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, %rax
	subq	%rax, %rsp          # a dynamic stack-pad with NO alloca annotation
	movq	$5, (%rsp)
	movq	(%rsp), %rax
	leaq	-8(%rbp), %rsp
	popq	%rbx
	popq	%rbp
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
