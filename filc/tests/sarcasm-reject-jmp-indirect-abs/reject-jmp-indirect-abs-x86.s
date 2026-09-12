	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# `jmp *myglobal` is an indirect jump THROUGH the absolute memory
	# operand myglobal (an absolute 8-byte read), not a direct branch to
	# it. No capability covers that read, so it cannot be bounds-checked;
	# the call/jmp code-target exemption must not apply to an
	# indirect-marked operand: reject (rather than silently dropping the
	# `*` and emitting a DIRECT `jmp myglobal`).
	movq	%rdi, %rax
	jmp	*myglobal
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
