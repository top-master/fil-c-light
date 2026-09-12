	.file	"rbp-o0.c"
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long()
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$416, %rsp
	leaq	-416(%rbp), %rcx   ;! alloca result size=400
	leaq	-416(%rbp), %rax
	movq	$55, 40(%rax)
	movq	40(%rcx), %rax
	leave
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
