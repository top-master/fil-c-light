	.arch_extension lse
	.text
	.global	f
	.type	f, %function
f:                              ;! int(ptr)
/* The atomic-ptr annotation is supported on arm64's cas — but NOT on the
   16-byte casp: a double-width compare-exchange cannot update an invisicap
   (intval, lower) pair atomically (same rejection as x86_64's cmpxchg16b). */
	mov	x1, x0
	casp	x2, x3, x4, x5, [x1]        ;! atomic ptr
	ret
	.size	f, .-f
