# BSWAP: single-operand byte swap -- a use+def of that ONE web, passed through
# raw. The swaps below run under register pressure (four webs live across
# them); the old conservative first-register-def model defined a fresh web with
# NO use, so the emitted bswap read an uninitialized temp and the input value
# was silently dropped (this leaked a runtime pointer in the audit probe).
	.text
	.globl	bswap_round
	.type	bswap_round, @function
bswap_round:                    ;! void(ptr)
	endbr64
	movq	%rdi, %rbx
	# 64-bit bswap: reverse, store, reverse back (round-trip).
	movq	(%rdi), %rax
	movq	$0x5555555555555555, %r12
	movq	$0x6666666666666666, %r13
	movq	$0x7777777777777777, %r14
	movq	$0x8888888888888888, %r15
	bswapq	%rax
	movq	%rax, 8(%rbx)
	bswapq	%rax
	movq	%rax, 16(%rbx)
	# 32-bit form (zero-extends into the web's low half).
	movl	24(%rdi), %eax
	bswap	%eax
	movl	%eax, 24(%rbx)
	# The pressure values must survive untouched.
	movq	%r12, 32(%rbx)
	movq	%r13, 40(%rbx)
	movq	%r14, 48(%rbx)
	movq	%r15, 56(%rbx)
	ret
	.size	bswap_round, .-bswap_round
	.section	.note.GNU-stack,"",@progbits
