	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# Far call: implicit far return-frame stack push (and a code-segment
	# change) that sarcasm cannot model: reject.
	lcall	*(%rdi)
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
