# movbe exists only as a byte-swapping move to/from MEMORY — the
# register-to-register spelling is not a baseline x86-64 encoding (gas only
# accepts it as an APX instruction), so it is rejected.
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	movbeq	%rsi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
