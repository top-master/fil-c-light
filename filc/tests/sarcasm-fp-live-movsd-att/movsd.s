	.text
	.globl	movsd_live
	.type	movsd_live, @function
movsd_live:                     ;! long(long, long)
	# xmm0 (accumulator) and xmm1 ((double)seed) are live at 8 bytes
	# (movsd/addsd scalar width) across the injected filc_allocate call
	# (the `;! alloca`) AND across every loop-back-edge pollcheck. The
	# width-aware fp save/restore must emit exactly ONE movsd store + ONE
	# movsd load per register at each of those sites — not 16 movdqu.
	# (-S verified: "movsd %xmm0, <slot0>(%rsp)" and
	# "movsd %xmm1, <slot1>(%rsp)" only.)
	cvtsi2sdq	%rsi, %xmm1
	pxor	%xmm0, %xmm0
	leaq	64(%rsp), %rax      ;! alloca result size=64
	movq	%rax, %r8
	testq	%rdi, %rdi
	je	.Ldone
.Lloop:
	addsd	%xmm1, %xmm0
	movsd	%xmm0, (%r8)
	subq	$1, %rdi
	jne	.Lloop
.Ldone:
	cvttsd2siq	%xmm0, %rax
	cvttsd2siq	%xmm1, %rcx
	addq	%rcx, %rax
	ret
	.size	movsd_live, .-movsd_live
	.section	.note.GNU-stack,"",@progbits
