# A local subroutine calling itself (direct recursion): with per-callsite
# cloning the continuations are fixed at compile time, so a re-entrant
# activation could never find its inner continuation — rejected at discovery.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	movq	%rdi, %r10
	call	recsub
	movq	%r9, %rax
	ret
	.size	foo, .-foo
	.type	recsub, @function
recsub:
	leaq	-1(%r10), %r10
	call	recsub
	leaq	1(%r9), %r9
	ret
	.size	recsub, .-recsub
	.section	.note.GNU-stack,"",@progbits
