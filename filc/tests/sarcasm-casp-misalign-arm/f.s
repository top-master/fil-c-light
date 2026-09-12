/* casp's natural alignment is 16 bytes: an 8-aligned-but-not-16 address must
   trip the alignment check with the TRUE alignment (16), not a raw hardware
   Alignment fault. */
	.arch_extension lse
	.text
	.global	g
	.type	g, %function
g:                              ;! void(ptr)
	mov	x8, #0
	mov	x9, #0
	mov	x10, #1
	mov	x11, #1
	casp	x8, x9, x10, x11, [x0]
	ret
	.size	g, .-g
