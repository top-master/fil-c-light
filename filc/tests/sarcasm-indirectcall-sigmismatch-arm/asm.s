	.text
	.p2align 4
	.global	foo
	.type	foo, %function
foo:                            ;! long(ptr, long)
	mov	x8, x0
	mov	x0, x1
	# The callsite declares the callee long(ptr) but main.c's bar is really
	# long(long): the signature numbers differ, so the runtime dispatch takes
	# the inlined generic buffer-CC path (not the fast path) and the call
	# still returns the right answer (the pointer-class argument word's aux
	# slot is a deterministic zero, and bar only reads the intval word).
	blr	x8 ;! long(ptr)
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
