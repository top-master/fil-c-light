/* An LSE swp on a read-only capability must trip the CanWrite branch of the
   access check (an atomic swap is a write). */
	.arch_extension lse
	.text
	.global	f
	.type	f, %function
f:                              ;! long(ptr, long)
	swp	x1, x8, [x0]
	mov	x0, x8
	ret
	.size	f, .-f
