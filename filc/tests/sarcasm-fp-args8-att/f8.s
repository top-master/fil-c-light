# The callee for the 8-double-argument signature. A signature with eight double
# arguments encodes to 8552919316, which is past imm32 -- so BOTH signature
# compare sites (the weak callsite thunk emitted for the cross-TU `call f8` in
# caller.s and the inline indirect-call sequence's cmpImmBranchWidened) must
# materialize the constant before comparing: `cmpq $8552919316, mem` does not
# exist (a cmp immediate is a sign-extended imm32), so sarcasm emits
# `movq $imm64, %reg` (the movabs encoding) + a register compare.
#
# f8 pins every argument: it returns sum(k * a_k) for k = 1..8 (a_0 has weight
# 1). All inputs in the tests are exact halves, so the result is exact.
	.text
	.p2align 4
	.globl	f8
	.type	f8, @function
f8:                             ;! double(double, double, double, double, double, double, double, double)
	endbr64
	movq	%rdi, %rax
	movsd	%xmm0, %xmm8
	movl	$2, %eax
	cvtsi2sdl	%eax, %xmm9
	mulsd	%xmm1, %xmm9
	addsd	%xmm9, %xmm8
	movl	$3, %eax
	cvtsi2sdl	%eax, %xmm9
	mulsd	%xmm2, %xmm9
	addsd	%xmm9, %xmm8
	movl	$4, %eax
	cvtsi2sdl	%eax, %xmm9
	mulsd	%xmm3, %xmm9
	addsd	%xmm9, %xmm8
	movl	$5, %eax
	cvtsi2sdl	%eax, %xmm9
	mulsd	%xmm4, %xmm9
	addsd	%xmm9, %xmm8
	movl	$6, %eax
	cvtsi2sdl	%eax, %xmm9
	mulsd	%xmm5, %xmm9
	addsd	%xmm9, %xmm8
	movl	$7, %eax
	cvtsi2sdl	%eax, %xmm9
	mulsd	%xmm6, %xmm9
	addsd	%xmm9, %xmm8
	movl	$8, %eax
	cvtsi2sdl	%eax, %xmm9
	mulsd	%xmm7, %xmm9
	addsd	%xmm9, %xmm8
	movsd	%xmm8, %xmm0
	ret
	.size	f8, .-f8
	.section	.note.GNU-stack,"",@progbits
