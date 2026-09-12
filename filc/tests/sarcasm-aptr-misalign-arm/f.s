/* A `;! atomic load ptr` through a base that is only 4-byte aligned must
   trip the alignment branch of the access check (pointer slots are 8 bytes). */
	.text
	.global	h
	.type	h, %function
h:                              ;! ptr(ptr)
	ldr	x0, [x0]        ;! atomic load ptr
	ret
	.size	h, .-h
