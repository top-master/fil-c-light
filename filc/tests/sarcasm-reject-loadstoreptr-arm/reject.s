/* The load-store-ptr annotation (the NON-atomic single-instruction RMW form,
   an x86 memory-destination ALU op) is rejected outright on arm64: no such
   instruction exists. Use separate load-ptr / store-ptr accesses, or the
   atomic-load-store-ptr annotation on an LSE RMW. */
	.text
	.global	f
	.type	f, %function
f:                              ;! long(ptr, long)
	add	x1, x1, x2        ;! load store ptr
	mov	x0, x1
	ret
	.size	f, .-f
