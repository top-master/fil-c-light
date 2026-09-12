/* Multi-structure NEON heap accesses at their exact structure widths:
   ld2/ld3/ld4 full-structure deinterleaves, st2/st4 interleaving stores,
   ld1r byte replicate, single-element ld1 lane load, and ld1 with register
   post-index. The drivers fill objects whose size equals the structure
   width (32/48/64 bytes), so a narrower check would trap. */
	.arch armv8-a
	.text
	.globl	deint2
	.type	deint2, %function
deint2:                         ;! void(ptr, ptr)
	ld2	{v0.16b, v1.16b}, [x0]
	stp	q0, q1, [x1]
	ret
	.size	deint2, .-deint2
	.globl	deint3
	.type	deint3, %function
deint3:                         ;! void(ptr, ptr)
	ld3	{v0.16b, v1.16b, v2.16b}, [x0]
	stp	q0, q1, [x1]
	str	q2, [x1, #32]
	ret
	.size	deint3, .-deint3
	.globl	deint4
	.type	deint4, %function
deint4:                         ;! void(ptr, ptr)
	ld4	{v0.16b, v1.16b, v2.16b, v3.16b}, [x0]
	stp	q0, q1, [x1]
	stp	q2, q3, [x1, #32]
	ret
	.size	deint4, .-deint4
	.globl	int2
	.type	int2, %function
int2:                           ;! void(ptr, ptr)
	ldp	q0, q1, [x0]
	st2	{v0.16b, v1.16b}, [x1]
	ret
	.size	int2, .-int2
	.globl	int4
	.type	int4, %function
int4:                           ;! void(ptr, ptr)
	ldp	q0, q1, [x0]
	ldp	q2, q3, [x0, #32]
	st4	{v0.4s, v1.4s, v2.4s, v3.4s}, [x1]
	ret
	.size	int4, .-int4
	.globl	repb
	.type	repb, %function
repb:                           ;! void(ptr, ptr)
	ld1r	{v0.16b}, [x0]
	str	q0, [x1]
	ret
	.size	repb, .-repb
	.globl	lane3
	.type	lane3, %function
lane3:                          ;! void(ptr, ptr)
	eor	v0.16b, v0.16b, v0.16b
	ld1	{v0.b}[3], [x0]
	str	q0, [x1]
	ret
	.size	lane3, .-lane3
	.globl	post2
	.type	post2, %function
post2:                          ;! void(ptr, ptr, long)
	ld1	{v0.16b}, [x0], x2
	ld1	{v1.16b}, [x0], x2
	stp	q0, q1, [x1]
	ret
	.size	post2, .-post2
	.section	.note.GNU-stack,"",@progbits
