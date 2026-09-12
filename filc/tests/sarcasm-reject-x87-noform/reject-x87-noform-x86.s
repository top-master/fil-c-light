	.intel_syntax noprefix
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# fst (non-popping) has no 10-byte memory form in the ISA (only fstp does):
	# reject instead of rendering a nonexistent instruction.
	fst	TBYTE PTR [rdi]
	mov	rax, rdi
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
