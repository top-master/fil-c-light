	.intel_syntax noprefix
	.text
	# Pseudoregisters in Intel-syntax files keep the `%` prefix (`%fil_<ident>`),
	# so a bare `fil_<ident>` can never shadow a same-named global.
	.globl	pseudo_intel
	.type	pseudo_intel, @function
pseudo_intel:                   ;! long(long, long)
	endbr64
	mov	%fil_a, rdi
	add	%fil_a, rsi
	mov	rax, %fil_a
	ret
	.size	pseudo_intel, .-pseudo_intel
	.section	.note.GNU-stack,"",@progbits
