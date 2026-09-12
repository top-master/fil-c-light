	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 512-byte fx-state load; the bounds check fires before execution. Load form.
	fxrstor	-16(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
