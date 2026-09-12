# A memory operand with NO base register and NO index is a displacement-only
# ABSOLUTE address: gas assembles `movq (4096), %rax` as `mov 0x1000,%rax` —
# the same un-checkable absolute-access class as the `movq 4096, %rax` moffs
# form (rejected by the sibling absaddr tests). This used to crash the
# renderer with "attempt to index nil with 'fixedNum'" instead of rejecting.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	endbr64
	movq	(4096), %rax
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
