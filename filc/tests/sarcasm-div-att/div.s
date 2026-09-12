	.text
	.globl	idiv_stress
	.type	idiv_stress, @function
idiv_stress:                    ;! long(ptr, ptr)
	# Signed 64-bit division under register pressure: dividend, divisor, the
	# output pointer, and five more values (eight webs) are all live across
	# cqo;idivq. Exercises the pin-in/pin-out modeling of the implicit
	# rdx:rax dividend use and quotient/remainder def: the virtual registers
	# must be copied into physical rax/rdx before the idiv and back out after.
	# rdi = in ([0]=dividend, [1]=divisor); rsi = out ([0]=quot, [1]=rem).
	movq	(%rdi), %rax
	movq	8(%rdi), %rcx
	movq	$11, %r8
	movq	$22, %r9
	movq	$33, %r10
	movq	$44, %r11
	movq	$55, %rdi
	cqo
	idivq	%rcx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	leaq	(%r8,%r9), %rax
	addq	%r10, %rax
	addq	%r11, %rax
	addq	%rdi, %rax
	ret
	.size	idiv_stress, .-idiv_stress

	.globl	div_uq
	.type	div_uq, @function
div_uq:                         ;! void(ptr)
	# Unsigned 64-bit div: rdi = [dividend, divisor, quotient out, rem out].
	movq	(%rdi), %rax
	movq	8(%rdi), %rcx
	xorl	%edx, %edx
	divq	%rcx
	movq	%rax, 16(%rdi)
	movq	%rdx, 24(%rdi)
	ret
	.size	div_uq, .-div_uq

	.globl	idiv_l
	.type	idiv_l, @function
idiv_l:                         ;! void(ptr)
	# 32-bit signed division with cltd (cdq) sign extension:
	# rdi = int[4]: dividend, divisor, quotient out, remainder out.
	movl	(%rdi), %eax
	movl	4(%rdi), %ecx
	cltd
	idivl	%ecx
	movl	%eax, 8(%rdi)
	movl	%edx, 12(%rdi)
	ret
	.size	idiv_l, .-idiv_l

	.globl	mul_q
	.type	mul_q, @function
mul_q:                          ;! void(ptr)
	# 128-bit unsigned product: rdx:rax = rax * r/m64. The multiplier is a
	# memory operand (checked 8-byte load at 8(%rdi)); both product halves
	# (the implicit rdx def and the rax def) are stored.
	# rdi = [a, b, lo out, hi out].
	movq	(%rdi), %rax
	mulq	8(%rdi)
	movq	%rax, 16(%rdi)
	movq	%rdx, 24(%rdi)
	ret
	.size	mul_q, .-mul_q

	.globl	imul_1op
	.type	imul_1op, @function
imul_1op:                       ;! void(ptr)
	# 1-operand signed imul: rdx:rax = rax * r/m64 (same implicit-register
	# modeling as mulq, signed semantics).
	movq	(%rdi), %rax
	imulq	8(%rdi)
	movq	%rax, 16(%rdi)
	movq	%rdx, 24(%rdi)
	ret
	.size	imul_1op, .-imul_1op

	.globl	idiv_mem
	.type	idiv_mem, @function
idiv_mem:                       ;! void(ptr, ptr)
	# Memory-form signed division. rdi = io ([0]=dividend in, [1]=quot out,
	# [2]=rem out); rsi points at a 16-byte object whose LAST 8 bytes hold
	# the divisor, so the divisor access must be checked at exactly 8 bytes.
	movq	(%rdi), %rax
	cqo
	idivq	8(%rsi)
	movq	%rax, 8(%rdi)
	movq	%rdx, 16(%rdi)
	ret
	.size	idiv_mem, .-idiv_mem

	.globl	sext_bw
	.type	sext_bw, @function
sext_bw:                        ;! void(ptr)
	# cbw/cwde modeling: byte at [0] of the 16-byte object at rdi is
	# sign-extended al->ax->eax and the 32-bit result stored at [4].
	movzbl	(%rdi), %eax
	cbtw
	cwtl
	movl	%eax, 4(%rdi)
	ret
	.size	sext_bw, .-sext_bw
	.section	.note.GNU-stack,"",@progbits
