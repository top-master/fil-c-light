/* FP entry signatures on arm64: float/double arguments pass in v0..v7 (in
   declaration order among the FP args alone; float = low 32 bits = sN, double =
   full dN) and GPR arguments pack densely into x2..x7 counting only GPR args.
   FP returns ride in v0 (s0/d0); the exception flag is w0. */
	.text
	.p2align 4
	.global	dmul
	.type	dmul, %function
dmul:                           ;! double(double, double)
	fmul	d0, d0, d1
	ret
	.size	dmul, .-dmul

	.p2align 4
	.global	fadd2
	.type	fadd2, %function
fadd2:                          ;! float(float, float)
	fadd	s0, s0, s1
	ret
	.size	fadd2, .-fadd2

	.p2align 4
	.global	dmix
	.type	dmix, %function
dmix:                           ;! double(int, double)
	scvtf	d9, x0
	fmul	d0, d9, d0
	ret
	.size	dmix, .-dmix

/* The money shot: GPR dense slots SKIP the FP args (double->v0, int->x2, float->v1,
   long->x3 in the fast CC; the yolo asm reads int in x0, float in s1, long in x1). */
	.p2align 4
	.global	mixed
	.type	mixed, %function
mixed:                          ;! long(double, int, float, long)
	fcvtzs	x9, d0
	mul	x9, x9, x0
	fcvtzs	x10, s1
	mul	x10, x10, x1
	add	x0, x9, x10
	ret
	.size	mixed, .-mixed

	.p2align 4
	.global	fconst
	.type	fconst, %function
fconst:                         ;! float(void)
	fmov	s0, #2.5
	ret
	.size	fconst, .-fconst

/* void return + FP args: compute a GPR from both FP args (pins their v-reg
   ordering: float arg -> s0/v0, double arg -> d1/v1) and hand it to a C helper
   that records it in a global. */
	.p2align 4
	.global	recordf
	.type	recordf, %function
recordf:                        ;! void(float, double)
	fcvtzs	x9, s0
	fcvtzs	x10, d1
	mul	x9, x9, x10
	add	x0, x9, x10
	bl	rec ;! void(long)
	ret
	.size	recordf, .-recordf
	.section	.note.GNU-stack,"",@progbits
