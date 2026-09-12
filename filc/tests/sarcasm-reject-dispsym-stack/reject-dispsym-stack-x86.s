	.file	"dispsym-stack.c"
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long()
	subq	$16, %rsp
	movq	bar(%rsp), %rax
	addq	$16, %rsp
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
