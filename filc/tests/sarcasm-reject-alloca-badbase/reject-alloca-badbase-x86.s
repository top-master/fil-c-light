	.file	"alloca-badbase.c"
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	subq	$408, %rsp
	leaq	(%rsp,%rdi,8), %rcx   ;! alloca result size=400
	movq	(%rcx), %rax
	addq	$408, %rsp
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
