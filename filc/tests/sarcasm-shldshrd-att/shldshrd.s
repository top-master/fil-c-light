# SHLD/SHRD dst, src, count: the destination is read AND written (a true RMW —
# the old unknown-mnemonic fallback modeled it as a pure def and dropped the
# destination's contribution to the result). Immediate and %cl counts (the
# only register-count encoding, pinned to physical rcx).
	.text
	.globl	shldshrd_ops
	.type	shldshrd_ops, @function
shldshrd_ops:                   ;! void(ptr)
	endbr64
	# shldl $5 with dst==src is a rotl32(5): 0x12345678 -> 0x468acf02
	movl	(%rdi), %eax
	shldl	$5, %eax, %eax
	movl	%eax, (%rdi)
	# shldl with distinct dst/src: dst = (dst<<imm) | (src >> (32-imm))
	movl	4(%rdi), %eax
	movl	8(%rdi), %ecx
	shldl	$9, %ecx, %eax
	movl	%eax, 4(%rdi)
	# shrdl dst==src is a rotr32: 0x89abcdef -> rotr(13)
	movl	12(%rdi), %edx
	shrdl	$13, %edx, %edx
	movl	%edx, 12(%rdi)
	# shrdq with distinct dst/src
	movq	16(%rdi), %r8
	movq	24(%rdi), %r9
	shrdq	$17, %r9, %r8
	movq	%r8, 16(%rdi)
	# shldq with a %cl count (pinned to rcx)
	movl	32(%rdi), %ecx
	movq	40(%rdi), %r10
	movq	48(%rdi), %r11
	shldq	%cl, %r11, %r10
	movq	%r10, 40(%rdi)
	# shrdl with a %cl count
	movl	56(%rdi), %eax
	shrdl	%cl, %eax, %eax
	movl	%eax, 56(%rdi)
	# under pressure
	movq	$0x1111111111111111, %r12
	movq	$0x2222222222222222, %r13
	movq	%r12, 64(%rdi)
	movq	%r13, 72(%rdi)
	ret
	.size	shldshrd_ops, .-shldshrd_ops
	.section	.note.GNU-stack,"",@progbits
