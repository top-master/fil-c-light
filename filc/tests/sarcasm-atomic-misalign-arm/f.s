/* An LSE RMW through a base that is only 4-byte aligned must trip the
   alignment branch of the access check: the hardware would take a raw
   Alignment fault on an unaligned atomic, so sarcasm checks NATURAL
   alignment (8 bytes for the 64-bit form) itself. */
	.arch_extension lse
	.text
	.global	f
	.type	f, %function
f:                              ;! void(ptr, long)
	ldadd	x1, x8, [x0]
	ret
	.size	f, .-f
