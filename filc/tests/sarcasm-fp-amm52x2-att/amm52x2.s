	.text
	.globl	amm52x2
	.type	amm52x2, @function
# Dual-channel 8-limb Almost-Montgomery-Multiply in radix 2^52, distilled from
# OpenSSL's ossl_rsaz_amm52x30_x2_ifma256 shape (rsaz-3k-avx512.pl): per channel
#   mulxq scalar chain + vpbroadcastq + vpmadd52luq/huq with memory operands +
#   valignq rotate; norm: vpsrlq/valignq $3 carry realign, vpblendd acc fold-in,
#   vpcmpuq {k} -> kmovb -> shlb/orb/adcb nibble dance -> masked vpsubq memop.
# Channel stride in a/b/m/res is 8 qwords; k0 is a 2-qword array.
# (res, a, b, m, k0) = (%rdi, %rsi, %rdx, %rcx, %r8)
amm52x2:                        ;! void(ptr, ptr, ptr, ptr, ptr)
	pushq	%rbx
	pushq	%rbp
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15

	vpxord	%ymm0, %ymm0, %ymm0
	vmovdqa64	%ymm0, %ymm3
	vmovdqa64	%ymm0, %ymm4
	vmovdqa64	%ymm0, %ymm5
	vmovdqa64	%ymm0, %ymm6

	xorl	%r9d, %r9d
	xorl	%r15d, %r15d

	movq	%rdx, %r11
	movq	$0xfffffffffffff, %rax

	movl	$8, %ebx

.align	32
.Lloop8:
	# ---- channel A: acc in %r9, bank %ymm3/%ymm4
	movq	0(%r11), %r13
	vpbroadcastq	%r13, %ymm1
	movq	0(%rsi), %rdx
	mulxq	%r13, %r13, %r12
	addq	%r13, %r9
	movq	%r12, %r10
	adcq	$0, %r10

	movq	0(%r8), %r13
	imulq	%r9, %r13
	andq	%rax, %r13

	vpbroadcastq	%r13, %ymm2
	movq	0(%rcx), %rdx
	mulxq	%r13, %r13, %r12
	addq	%r13, %r9
	adcq	%r12, %r10

	shrq	$52, %r9
	salq	$12, %r10
	orq	%r10, %r9

	vpmadd52luq	0(%rsi), %ymm1, %ymm3
	vpmadd52luq	32(%rsi), %ymm1, %ymm4
	vpmadd52luq	0(%rcx), %ymm2, %ymm3
	vpmadd52luq	32(%rcx), %ymm2, %ymm4

	valignq	$1, %ymm3, %ymm4, %ymm3
	valignq	$1, %ymm4, %ymm0, %ymm4

	vmovq	%xmm3, %r13
	addq	%r13, %r9

	vpmadd52huq	0(%rsi), %ymm1, %ymm3
	vpmadd52huq	32(%rsi), %ymm1, %ymm4
	vpmadd52huq	0(%rcx), %ymm2, %ymm3
	vpmadd52huq	32(%rcx), %ymm2, %ymm4

	# ---- channel B: acc in %r15, bank %ymm5/%ymm6
	movq	64(%r11), %r13
	vpbroadcastq	%r13, %ymm1
	movq	64(%rsi), %rdx
	mulxq	%r13, %r13, %r12
	addq	%r13, %r15
	movq	%r12, %r10
	adcq	$0, %r10

	movq	8(%r8), %r13
	imulq	%r15, %r13
	andq	%rax, %r13

	vpbroadcastq	%r13, %ymm2
	movq	64(%rcx), %rdx
	mulxq	%r13, %r13, %r12
	addq	%r13, %r15
	adcq	%r12, %r10

	shrq	$52, %r15
	salq	$12, %r10
	orq	%r10, %r15

	vpmadd52luq	64(%rsi), %ymm1, %ymm5
	vpmadd52luq	96(%rsi), %ymm1, %ymm6
	vpmadd52luq	64(%rcx), %ymm2, %ymm5
	vpmadd52luq	96(%rcx), %ymm2, %ymm6

	valignq	$1, %ymm5, %ymm6, %ymm5
	valignq	$1, %ymm6, %ymm0, %ymm6

	vmovq	%xmm5, %r13
	addq	%r13, %r15

	vpmadd52huq	64(%rsi), %ymm1, %ymm5
	vpmadd52huq	96(%rsi), %ymm1, %ymm6
	vpmadd52huq	64(%rcx), %ymm2, %ymm5
	vpmadd52huq	96(%rcx), %ymm2, %ymm6

	leaq	8(%r11), %r11
	decl	%ebx
	jne	.Lloop8

	# ---- norm channel A
	vpbroadcastq	%r9, %ymm0
	vpblendd	$3, %ymm0, %ymm3, %ymm3

	vpsrlq	$52, %ymm3, %ymm0
	vpsrlq	$52, %ymm4, %ymm1

	valignq	$3, %ymm0, %ymm1, %ymm1
	valignq	$3, .Lzeros(%rip), %ymm0, %ymm0

	vpandq	.Lmask52x4(%rip), %ymm3, %ymm3
	vpandq	.Lmask52x4(%rip), %ymm4, %ymm4

	vpaddq	%ymm0, %ymm3, %ymm3
	vpaddq	%ymm1, %ymm4, %ymm4

	vpcmpuq	$6, .Lmask52x4(%rip), %ymm3, %k1
	vpcmpuq	$6, .Lmask52x4(%rip), %ymm4, %k2
	kmovb	%k1, %r14d
	kmovb	%k2, %r13d
	shlb	$4, %r13b
	orb	%r13b, %r14b
	addb	%r14b, %r14b

	vpcmpuq	$0, .Lmask52x4(%rip), %ymm3, %k1
	vpcmpuq	$0, .Lmask52x4(%rip), %ymm4, %k2
	kmovb	%k1, %r9d
	kmovb	%k2, %r13d
	shlb	$4, %r13b
	orb	%r13b, %r9b

	addb	%r9b, %r14b
	xorb	%r9b, %r14b

	kmovb	%r14d, %k1
	shrb	$4, %r14b
	kmovb	%r14d, %k2

	vpsubq	.Lmask52x4(%rip), %ymm3, %ymm3{%k1}
	vpsubq	.Lmask52x4(%rip), %ymm4, %ymm4{%k2}

	vpandq	.Lmask52x4(%rip), %ymm3, %ymm3
	vpandq	.Lmask52x4(%rip), %ymm4, %ymm4

	# ---- norm channel B
	vpbroadcastq	%r15, %ymm0
	vpblendd	$3, %ymm0, %ymm5, %ymm5

	vpsrlq	$52, %ymm5, %ymm0
	vpsrlq	$52, %ymm6, %ymm1

	valignq	$3, %ymm0, %ymm1, %ymm1
	valignq	$3, .Lzeros(%rip), %ymm0, %ymm0

	vpandq	.Lmask52x4(%rip), %ymm5, %ymm5
	vpandq	.Lmask52x4(%rip), %ymm6, %ymm6

	vpaddq	%ymm0, %ymm5, %ymm5
	vpaddq	%ymm1, %ymm6, %ymm6

	vpcmpuq	$6, .Lmask52x4(%rip), %ymm5, %k1
	vpcmpuq	$6, .Lmask52x4(%rip), %ymm6, %k2
	kmovb	%k1, %r14d
	kmovb	%k2, %r13d
	shlb	$4, %r13b
	orb	%r13b, %r14b
	addb	%r14b, %r14b

	vpcmpuq	$0, .Lmask52x4(%rip), %ymm5, %k1
	vpcmpuq	$0, .Lmask52x4(%rip), %ymm6, %k2
	kmovb	%k1, %r15d
	kmovb	%k2, %r13d
	shlb	$4, %r13b
	orb	%r13b, %r15b

	addb	%r15b, %r14b
	xorb	%r15b, %r14b

	kmovb	%r14d, %k1
	shrb	$4, %r14b
	kmovb	%r14d, %k2

	vpsubq	.Lmask52x4(%rip), %ymm5, %ymm5{%k1}
	vpsubq	.Lmask52x4(%rip), %ymm6, %ymm6{%k2}

	vpandq	.Lmask52x4(%rip), %ymm5, %ymm5
	vpandq	.Lmask52x4(%rip), %ymm6, %ymm6

	vmovdqu64	%ymm3, 0(%rdi)
	vmovdqu64	%ymm4, 32(%rdi)
	vmovdqu64	%ymm5, 64(%rdi)
	vmovdqu64	%ymm6, 96(%rdi)

	vzeroupper
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	popq	%rbp
	popq	%rbx
	ret
	.size	amm52x2, .-amm52x2

	.section .rodata
	.align 32
.Lmask52x4:
	.quad	0xfffffffffffff
	.quad	0xfffffffffffff
	.quad	0xfffffffffffff
	.quad	0xfffffffffffff
.Lzeros:
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.section	.note.GNU-stack,"",@progbits
