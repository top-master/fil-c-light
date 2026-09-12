/* The atomic-load-store-ptr annotation requires an LSE atomic
   read-modify-write (ldadd/ldset/ldeor/ldclr/swp): ldr is not an RMW, and
   arm64 has no plain memory-destination ALU RMW to accept instead. */
	.text
	.global	f
	.type	f, %function
f:                              ;! ptr(ptr)
	ldr	x0, [x0]          ;! atomic load store ptr
	ret
	.size	f, .-f
