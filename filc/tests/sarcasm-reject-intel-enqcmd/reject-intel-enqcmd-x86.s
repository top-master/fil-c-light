	.intel_syntax noprefix
	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr, ptr)
	# Unknown mnemonic with an AT&T-style parens memory operand in
	# Intel-syntax input: must hit the AT&T-operand rejection, not fall
	# through to parseSym (which would render an unchecked access).
	enqcmd	%rsi, (%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
