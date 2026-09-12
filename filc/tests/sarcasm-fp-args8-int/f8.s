# The callee for the 8-double-argument signature (Intel syntax input; sarcasm
# output is always AT&T). A signature with eight double arguments encodes to
# 8552919316, which is past imm32 -- so BOTH signature compare sites must
# materialize the constant before comparing: `cmp $8552919316, mem` does not
# exist (a cmp immediate is a sign-extended imm32), so sarcasm emits a 64-bit
# movabs + register compare.
#
# f8 pins every argument: it returns sum(k * a_k) for k = 1..8 (a_0 has weight
# 1). All inputs in the tests are exact halves, so the result is exact.
	.text
	.intel_syntax noprefix
	.p2align 4
	.globl	f8
	.type	f8, @function
f8:                             ;! double(double, double, double, double, double, double, double, double)
	movsd	xmm8, xmm0
	mov	eax, 2
	cvtsi2sdl	xmm9, eax
	mulsd	xmm9, xmm1
	addsd	xmm8, xmm9
	mov	eax, 3
	cvtsi2sdl	xmm9, eax
	mulsd	xmm9, xmm2
	addsd	xmm8, xmm9
	mov	eax, 4
	cvtsi2sdl	xmm9, eax
	mulsd	xmm9, xmm3
	addsd	xmm8, xmm9
	mov	eax, 5
	cvtsi2sdl	xmm9, eax
	mulsd	xmm9, xmm4
	addsd	xmm8, xmm9
	mov	eax, 6
	cvtsi2sdl	xmm9, eax
	mulsd	xmm9, xmm5
	addsd	xmm8, xmm9
	mov	eax, 7
	cvtsi2sdl	xmm9, eax
	mulsd	xmm9, xmm6
	addsd	xmm8, xmm9
	mov	eax, 8
	cvtsi2sdl	xmm9, eax
	mulsd	xmm9, xmm7
	addsd	xmm8, xmm9
	movsd	xmm0, xmm8
	ret
	.size	f8, .-f8
	.section	.note.GNU-stack,"",@progbits
