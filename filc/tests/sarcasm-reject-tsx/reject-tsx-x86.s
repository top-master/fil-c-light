# TSX transactional memory (xbegin/xend/xabort) has transactional control flow
# and memory semantics the checker cannot model: the xbegin fallback label is
# unmodeled control flow (and on TSX-less hardware the encodings are #UD, an
# unconverted signal). The label form must be rejected as the instruction it
# is, not mistaken for a plain branch.
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	endbr64
	movq	%rdi, %rax
.Lfallback:
	xbegin	.Lfallback
	xend
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
