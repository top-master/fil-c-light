	.text
	.globl	bmi_q
	.type	bmi_q, @function
bmi_q:                          ;! void(ptr, ptr)
	# BMI1/BMI2/bsf/bsr acceptance with exact widths. rdi points at a 16-byte
	# object; the q-form memory operands read its LAST 8 bytes (offset 8) and
	# the 32-bit andn reads its LAST 4 bytes (offset 12), so an over-wide
	# width model would trap. rsi -> long[14] results (entry 13 is 32-bit).
	movq	$7, %rcx
	shlxq	%rcx, 8(%rdi), %rax
	movq	%rax, (%rsi)
	shrxq	%rcx, 8(%rdi), %rax
	movq	%rax, 8(%rsi)
	sarxq	%rcx, 8(%rdi), %rax
	movq	%rax, 16(%rsi)
	rorxq	$13, 8(%rdi), %rax
	movq	%rax, 24(%rsi)
	blsiq	8(%rdi), %rax
	movq	%rax, 32(%rsi)
	blsrq	8(%rdi), %rax
	movq	%rax, 40(%rsi)
	blsmskq	8(%rdi), %rax
	movq	%rax, 48(%rsi)
	movq	$0x1404, %rdx           # bextr control: start=4, length=20
	bextrq	%rdx, 8(%rdi), %rax
	movq	%rax, 56(%rsi)
	movq	$23, %rdx
	bzhiq	%rdx, 8(%rdi), %rax
	movq	%rax, 64(%rsi)
	movq	$0x1111111111111111, %r8
	pdepq	8(%rdi), %r8, %rax
	movq	%rax, 72(%rsi)
	pextq	8(%rdi), %r8, %rax
	movq	%rax, 80(%rsi)
	bsfq	8(%rdi), %rax
	movq	%rax, 88(%rsi)
	bsrq	8(%rdi), %rax
	movq	%rax, 96(%rsi)
	movl	$0x0F0F0F0F, %ecx
	andnl	12(%rdi), %ecx, %eax    # eax = ~ecx & mem32
	movl	%eax, 104(%rsi)
	ret
	.size	bmi_q, .-bmi_q
	.section	.note.GNU-stack,"",@progbits
