	.file	"mov-base.c"
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long()
	subq	$408, %rsp
	leaq	-120(%rsp), %rcx   ;! alloca result size=400
	movq	$77, 120(%rcx)
	movq	%rsp, %rax
	movq	(%rax), %rax
	addq	$408, %rsp
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
