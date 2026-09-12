# FP entry signatures on x86_64: float/double arguments pass in xmm0..xmm7 (in
# declaration order among the FP args alone) and GPR arguments pack densely into
# rdx,rcx,r8,r9 counting only GPR args. FP returns ride in xmm0; the exception
# flag is %al. (The endbr64/movq marker in dmul is for architecture detection.)
	.text
	.p2align 4
	.globl	dmul
	.type	dmul, @function
dmul:                           ;! double(double, double)
	endbr64
	movq	%rdi, %rax
	mulsd	%xmm1, %xmm0
	ret
	.size	dmul, .-dmul

	.p2align 4
	.globl	fadd2
	.type	fadd2, @function
fadd2:                          ;! float(float, float)
	addss	%xmm1, %xmm0
	ret
	.size	fadd2, .-fadd2

	.p2align 4
	.globl	dmix
	.type	dmix, @function
dmix:                           ;! double(int, double)
	# int arg -> %rdi (the first non-FP yolo arg); double arg -> %xmm0.
	cvtsi2sdq	%rdi, %xmm1
	mulsd	%xmm1, %xmm0
	ret
	.size	dmix, .-dmix

# The money shot: GPR dense slots SKIP the FP args (double->xmm0, int->rdx,
# float->xmm1, long->rcx in the fast CC; the yolo asm reads the int in %rdi,
# the float in %xmm1, the long in %rsi).
	.p2align 4
	.globl	mixed
	.type	mixed, @function
mixed:                          ;! long(double, int, float, long)
	cvttsd2si	%xmm0, %rax
	imulq	%rdi, %rax
	cvttss2si	%xmm1, %rdx
	imulq	%rsi, %rdx
	addq	%rdx, %rax
	ret
	.size	mixed, .-mixed

	.p2align 4
	.globl	fconst
	.type	fconst, @function
fconst:                         ;! float(void)
	movl	$0x40200000, %eax       # 2.5f
	movl	%eax, -8(%rsp)
	movss	-8(%rsp), %xmm0
	ret
	.size	fconst, .-fconst

# void return + FP args: compute a GPR from both FP args (pins their xmm
# ordering: float arg -> %xmm0, double arg -> %xmm1) and hand it to a C helper
# that records it in a global.
	.p2align 4
	.globl	recordf
	.type	recordf, @function
recordf:                        ;! void(float, double)
	cvttss2si	%xmm0, %rax
	cvttsd2si	%xmm1, %rdx
	imulq	%rdx, %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	rec ;! void(long)
	ret
	.size	recordf, .-recordf
	.section	.note.GNU-stack,"",@progbits
