	.file	"redirect-lea.c"
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long()
	subq	$408, %rsp
	leaq	-120(%rsp), %rcx   ;! alloca result size=400
	leaq	24(%rsp), %rax
	movq	$9, (%rax)
	movq	144(%rcx), %rdx
	movq	$5, 144(%rcx)
	movq	(%rax), %rax
	shlq	$3, %rax
	addq	%rdx, %rax
	addq	$408, %rsp
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
