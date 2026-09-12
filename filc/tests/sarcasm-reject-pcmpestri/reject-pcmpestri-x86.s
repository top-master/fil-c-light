	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# pcmpestri has implicit GPR operands (rax/rdx string lengths, rcx
	# result) that sarcasm does not model: reject.
	pcmpestri	$0, (%rdi), %xmm0
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
