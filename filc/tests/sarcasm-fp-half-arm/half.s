/* ARMv8.2 half-precision: fadd/fsub/fmul/fdiv on h registers, fcvt between
   h and s/d, and h-width heap accesses (str h at offset 14 of a 16-byte
   object must pass the exact 2-byte access check). Inputs arrive as float
   bit patterns in w registers (signatures are integer/ptr only). */
	.arch armv8.2-a+fp16
	.text
	.globl	f_half
	.type	f_half, %function
f_half:                         ;! long(ptr, long, long)
	fmov	s0, w1
	fmov	s1, w2
	fcvt	h2, s0
	fcvt	h3, s1
	fadd	h4, h2, h3
	fmul	h5, h2, h3
	fsub	h6, h2, h3
	fdiv	h7, h2, h3
	fcvt	d0, h4
	str	d0, [x0]
	str	h5, [x0, #14]
	ldr	h8, [x0, #14]
	fcvtzs	w3, h4
	fcvtzs	w4, h5
	add	w3, w3, w4
	fcvtzs	w4, h6
	add	w3, w3, w4
	fcvtzs	w4, h7
	add	w3, w3, w4
	fcvtzs	w4, h8
	add	w3, w3, w4
	mov	x0, x3
	ret
	.size	f_half, .-f_half
	.section	.note.GNU-stack,"",@progbits
