	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 512-byte fx-state store; the bounds check fires before execution, so fxsave's 64-byte-execution-alignment rule never applies. Store form.
	fxsave	-16(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
