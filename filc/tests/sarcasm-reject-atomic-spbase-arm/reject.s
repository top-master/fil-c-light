/* An LSE atomic with an sp base: sarcasm cannot prove safety of a stack
   slot accessed through a raw sp operand on the atomic forms (bare [Xn]
   bases only), so it rejects rather than miscompile. */
	.arch_extension lse
	.text
	.global	f
	.type	f, %function
f:                              ;! long(ptr)
	swp	x0, x1, [sp]
	mov	x0, x1
	ret
	.size	f, .-f
