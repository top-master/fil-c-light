	.text
	.globl	fpsum
	.type	fpsum, @function
fpsum:                          ;! long(ptr, long)
	pxor	%xmm0, %xmm0
	testq	%rsi, %rsi
	je	.Ldone
.Lloop:
	addsd	(%rdi), %xmm0
	addq	$8, %rdi
	subq	$1, %rsi
	jne	.Lloop
.Ldone:
	cvttsd2siq	%xmm0, %rax
	ret
	.size	fpsum, .-fpsum
	.section	.note.GNU-stack,"",@progbits
