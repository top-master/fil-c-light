	.intel_syntax noprefix
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# Regression test: movnti's memory width is determined by the SOURCE
	# REGISTER (%rsi -> 8 bytes); a DWORD PTR (4-byte) annotation contradicts
	# it and must reject (it would under-size the bounds check of the
	# non-temporal store).
	movnti	DWORD PTR [rdi], rsi
	mov	rax, rdi
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
