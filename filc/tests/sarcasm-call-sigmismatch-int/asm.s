	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	calladd7
	.type	calladd7, @function
calladd7:                       ;! long()
	endbr64
	mov	rdi, 0
	# add7 is not defined in this module, so the direct call goes through the
	# weak pizlonatedFI1066_add7 callsite resolver. The callsite declares the
	# callee long(ptr) (signature 1066) but add7 is really long(long)
	# (signature 270), so the resolver's signature check misses and it must
	# take its generic buffer-CC path: the null pointer rides the buffer as a
	# zero intval word (with a zero aux word), add7 receives 0 and returns 7,
	# and the resolver checks the returned ret size (8) before unmarshalling
	# the result.
	call	add7          ;! long(ptr)
	ret
	.size	calladd7, .-calladd7
	.section	.note.GNU-stack,"",@progbits
