	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# `call *myglobal` calls THROUGH the absolute memory operand myglobal:
	# an absolute 8-byte read no capability covers, so it cannot be
	# bounds-checked. Reject like every other moffs form (the Intel
	# spelling `call QWORD PTR [myglobal]` already rejects via its
	# symbolic displacement; the AT&T spelling must not slip through).
	movq	%rdi, %rax
	call	*myglobal
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
