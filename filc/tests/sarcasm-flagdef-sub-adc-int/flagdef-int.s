# Intel-syntax twin of the flagDef `sub`-feeds-`adc` shape (see the -att test).
	.intel_syntax noprefix
	.text
	.globl	flagdef_sub_adc
	.type	flagdef_sub_adc, @function
flagdef_sub_adc:                ;! long(long,long)
	mov	r13, rdi
	mov	rbp, rsi
	xor	rax, rax
	sub	rbp, r13                # CF = (b < a); rbp's value is dead after this
	adc	rax, rax                # rax = CF (needs the sub's flags, not xor's)
	ret
	.size	flagdef_sub_adc, .-flagdef_sub_adc
	.section	.note.GNU-stack,"",@progbits
