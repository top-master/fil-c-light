# A local subroutine containing an ANNOTATED real call (the retaddr temp must
# stay live across it — IRC keeps it callee-saved or spilled). Convention:
# %r10 -> %r9; the sub calls the C function cfunc(x) and doubles the result.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	movq	%rdi, %r10
	call	wrap
	movq	%r9, %rbx
	leaq	2(%rbx), %r10
	call	wrap
	leaq	(%rbx,%r9), %rax
	ret
	.size	foo, .-foo
	.type	wrap, @function
wrap:
	movq	%r10, %rdi
	call	cfunc               ;! long(long)
	leaq	(%rax,%rax), %r9
	ret
	.size	wrap, .-wrap
	.section	.note.GNU-stack,"",@progbits
