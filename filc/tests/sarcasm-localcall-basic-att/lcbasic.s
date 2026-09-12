# A file-local subroutine with a custom register convention (arg in %r10,
# result in %r9), called twice from an exported function. Each call is an
# unconditional jump to the per-caller clone; the sub's ret dispatches on the
# materialized continuation address.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	movq	%rdi, %r10
	call	dbladd
	leaq	(%r9,%r9), %rbx
	movq	%rbx, %r10
	call	dbladd
	leaq	(%rbx,%r9), %rax
	ret
	.size	foo, .-foo
	.type	dbladd, @function
dbladd:
	leaq	(%r10,%r10), %r9
	addq	$3, %r9
	ret
	.size	dbladd, .-dbladd
	.section	.note.GNU-stack,"",@progbits
