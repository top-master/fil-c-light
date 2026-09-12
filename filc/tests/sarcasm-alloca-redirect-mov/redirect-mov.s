	.file	"redirect-mov.c"
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long()
	subq	$408, %rsp
	movq	%rsp, %rcx          ;! alloca result size=400
	movq	%rsp, %rax
	movq	$33, 24(%rax)
	movq	24(%rcx), %rax
	addq	$408, %rsp
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
