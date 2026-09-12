/* An LSE RMW past the end of the object must trip the upper-bound branch of
   the access check (an atomic ldadd is a write). */
	.arch_extension lse
	.text
	.global	f
	.type	f, %function
f:                              ;! void(ptr, long)
	ldadd	x1, x8, [x0]
	ret
	.size	f, .-f
