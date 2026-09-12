# Regression guard: a `.type sub,@function` label with no signature that is
# NEVER called as a local subroutine keeps the plain no-signature error (only
# called labels are claimed by local-subroutine discovery).
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long()
	movl	$42, %eax
	ret
	.size	foo, .-foo
	.type	deadsub, @function
deadsub:
	movq	%r10, %r9
	ret
	.size	deadsub, .-deadsub
	.section	.note.GNU-stack,"",@progbits
