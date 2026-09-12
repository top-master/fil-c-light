/* The LOAD annotation on a STORE: the atomic-load-ptr annotation requires a
   plain 64-bit scalar load (ldr/ldur/ldar/ldapr), never str. */
	.text
	.global	f
	.type	f, %function
f:                              ;! void(ptr, ptr)
	str	x1, [x0]          ;! atomic load ptr
	ret
	.size	f, .-f
