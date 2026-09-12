# Two exported functions calling the SAME local subroutine (foo 3 times, bar
# 2): each caller gets its own clone of the sub (custom convention: arg %r10,
# result %r9).
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	movq	%rdi, %r10
	call	worker
	movq	%r9, %rbx
	leaq	1(%rbx), %r10
	call	worker
	addq	%r9, %rbx
	leaq	1(%rbx), %r10
	call	worker
	leaq	(%rbx,%r9), %rax
	ret
	.size	foo, .-foo
	.globl	bar
	.type	bar, @function
bar:                            ;! long(long)
	movq	%rdi, %r10
	call	worker
	movq	%r9, %rbx
	leaq	(%rbx,%rbx), %r10
	call	worker
	leaq	(%rbx,%r9), %rax
	ret
	.size	bar, .-bar
	.type	worker, @function
worker:
	imulq	$5, %r10, %r9
	subq	$2, %r9
	ret
	.size	worker, .-worker
	.section	.note.GNU-stack,"",@progbits
