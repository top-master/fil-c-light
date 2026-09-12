	.file	"rbp-rsp-alias.c"
	.text
	.globl	foo_alias
	.type	foo_alias, @function
foo_alias:                      ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	$42, 8(%rsp)
	movq	-8(%rbp), %rax
	leave
	ret
	.size	foo_alias, .-foo_alias
	.globl	foo_distinct
	.type	foo_distinct, @function
foo_distinct:                   ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	$42, -8(%rsp)
	movq	-8(%rbp), %rax
	leave
	ret
	.size	foo_distinct, .-foo_distinct
	.section	.note.GNU-stack,"",@progbits
