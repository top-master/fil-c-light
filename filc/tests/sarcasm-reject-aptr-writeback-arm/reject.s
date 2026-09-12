/* Writeback addressing is rejected on every pointer annotation: no atomic
   form has it, so the address update must be split from the access. */
	.text
	.global	f
	.type	f, %function
f:                              ;! ptr(ptr)
	ldr	x0, [x0, #8]!     ;! atomic load ptr
	ret
	.size	f, .-f
