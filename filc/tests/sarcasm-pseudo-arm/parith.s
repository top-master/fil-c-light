	.text
	// Pseudoregisters on arm64: bare `fil_<ident>` 64-bit GPRs (idents may
	// start with a digit). pseudo_sum checks def/use of several pseudos;
	// pseudo_ptr checks memory traffic through a pseudo-held pointer.
	.globl	pseudo_sum
	.type	pseudo_sum, @function
pseudo_sum:                     //! long(long, long, long)
	mov	fil_a, x0
	mov	fil_1b, x1
	mov	fil_c, x2
	add	fil_a, fil_a, fil_1b
	add	fil_a, fil_a, fil_c
	mov	x0, fil_a
	ret
	.size	pseudo_sum, .-pseudo_sum
	.globl	pseudo_ptr
	.type	pseudo_ptr, @function
pseudo_ptr:                     //! long(ptr, long)
	mov	fil_base, x0
	mov	fil_idx, x1
	ldr	x0, [fil_base, fil_idx, lsl #3]
	ret
	.size	pseudo_ptr, .-pseudo_ptr
	.section	.note.GNU-stack,"",@progbits
