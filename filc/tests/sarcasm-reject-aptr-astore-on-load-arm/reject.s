/* The STORE annotation on a LOAD: the atomic-store-ptr annotation requires a
   plain 64-bit scalar store (str/stur/stlr), never ldr. */
	.text
	.global	f
	.type	f, %function
f:                              ;! ptr(ptr)
	ldr	x0, [x0]          ;! atomic store ptr
	ret
	.size	f, .-f
