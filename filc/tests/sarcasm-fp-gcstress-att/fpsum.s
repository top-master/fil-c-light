	.text
	.globl	fpsum_gc
	.type	fpsum_gc, @function
fpsum_gc:                       ;! long(long)
	movabsq	$4607182418800017408, %rax
	movq	%rax, %xmm1
	movabsq	$4611686018427387904, %rcx
	movq	%rcx, %xmm6
	pxor	%xmm0, %xmm0
	pxor	%xmm7, %xmm7
	testq	%rdi, %rdi
	je	.Ldone
.Lloop:
	addsd	%xmm1, %xmm0
	addsd	%xmm6, %xmm7
	subq	$1, %rdi
	jne	.Lloop
.Ldone:
	cvttsd2siq	%xmm0, %rax
	cvttsd2siq	%xmm7, %rcx
	addq	%rcx, %rax
	ret
	.size	fpsum_gc, .-fpsum_gc
	.section	.note.GNU-stack,"",@progbits
