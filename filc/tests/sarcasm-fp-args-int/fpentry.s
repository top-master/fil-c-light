# FP entry signatures on x86_64 (Intel syntax input; sarcasm output is always
# AT&T): float/double arguments pass in xmm0..xmm7 (in declaration order among
# the FP args alone) and GPR arguments pack densely into rdx,rcx,r8,r9 counting
# only GPR args. FP returns ride in xmm0; the exception flag is %al.
	.text
	.intel_syntax noprefix
	.p2align 4
	.globl	dmul
	.type	dmul, @function
dmul:                           ;! double(double, double)
	mulsd	xmm0, xmm1
	ret
	.size	dmul, .-dmul

	.p2align 4
	.globl	fadd2
	.type	fadd2, @function
fadd2:                          ;! float(float, float)
	addss	xmm0, xmm1
	ret
	.size	fadd2, .-fadd2

	.p2align 4
	.globl	dmix
	.type	dmix, @function
dmix:                           ;! double(int, double)
	# int arg -> rdi (the first non-FP yolo arg); double arg -> xmm0.
	cvtsi2sdq	xmm1, rdi
	mulsd	xmm0, xmm1
	ret
	.size	dmix, .-dmix

# The money shot: GPR dense slots SKIP the FP args (double->xmm0, int->rdx,
# float->xmm1, long->rcx in the fast CC; the yolo asm reads the int in rdi,
# the float in xmm1, the long in rsi).
	.p2align 4
	.globl	mixed
	.type	mixed, @function
mixed:                          ;! long(double, int, float, long)
	cvttsd2si	rax, xmm0
	imul	rax, rdi
	cvttss2si	rdx, xmm1
	imul	rdx, rsi
	add	rax, rdx
	ret
	.size	mixed, .-mixed

	.p2align 4
	.globl	fconst
	.type	fconst, @function
fconst:                         ;! float(void)
	mov	eax, 0x40200000         # 2.5f
	mov	DWORD PTR -8[rsp], eax
	movss	xmm0, DWORD PTR -8[rsp]
	ret
	.size	fconst, .-fconst

# void return + FP args: compute a GPR from both FP args (pins their xmm
# ordering: float arg -> xmm0, double arg -> xmm1) and hand it to a C helper
# that records it in a global.
	.p2align 4
	.globl	recordf
	.type	recordf, @function
recordf:                        ;! void(float, double)
	cvttss2si	rax, xmm0
	cvttsd2si	rdx, xmm1
	imul	rax, rdx
	add	rax, rdx
	mov	rdi, rax
	call	rec ;! void(long)
	ret
	.size	recordf, .-recordf
	.section	.note.GNU-stack,"",@progbits
