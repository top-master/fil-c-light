	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	endbr64
	movq	%rdi, %rax
	# A raw register branch (`jmp *%rax`, e.g. a computed goto or a switch jump
	# table) has no provable target: the renderer would pass it through
	# verbatim as an uncontrolled branch. Rejected, exactly like arm64's
	# `br xN` / `b xN`.
	jmp	*%rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
