# swapgs swaps the gs.base thread-pointer base, which the Fil-C runtime owns:
# executing it in user code silently corrupts thread-local state for the whole
# thread (with no fault and no filc panic). Must be a clean compile-time
# rejection, not a raw passthrough.
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	endbr64
	movq	%rdi, %rax
	swapgs
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
