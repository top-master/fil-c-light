# Loop-carried pointer swaps (the keccak1600 bounce-buffer shape): two pointer
# webs are exchanged every iteration, so each web's runtime value alternates
# between two pointer origins. No STATIC capability lower is correct for such a
# web — the lowers must swap in lockstep with the intvals (ptrflow's
# dynamic-lower widening). The xchg form previously compiled with the wrong
# (stale) capabilities — false traps at runtime — and the three-move rotation
# form never converged in pointer-flow analysis at all.
	.text
	.globl	swap_xchg
	.type	swap_xchg, @function
swap_xchg:                      ;! void(ptr, ptr, size_t)
	endbr64
.Loop_xchg:
	movq	(%rdi), %rax     # swap the pointed-to words ...
	movq	(%rsi), %rcx
	movq	%rcx, (%rdi)
	movq	%rax, (%rsi)
	xchgq	%rsi, %rdi       # ... then swap the pointers themselves
	subq	$1, %rdx
	jnz	.Loop_xchg
	ret
	.size	swap_xchg, .-swap_xchg
	.globl	swap_moves
	.type	swap_moves, @function
swap_moves:                     ;! void(ptr, ptr, size_t)
	endbr64
.Loop_moves:
	movq	(%rdi), %rax
	movq	(%rsi), %rcx
	movq	%rcx, (%rdi)
	movq	%rax, (%rsi)
	movq	%rdi, %rax       # the three-move rotation form of the same swap
	movq	%rsi, %rdi
	movq	%rax, %rsi
	subq	$1, %rdx
	jnz	.Loop_moves
	ret
	.size	swap_moves, .-swap_moves
	.globl	xchg_straight
	.type	xchg_straight, @function
xchg_straight:                  ;! void(ptr, ptr)
	endbr64
	# A STRAIGHT-LINE xchg (no loop): the def webs are fresh, so the crossed
	# lowers propagate exactly — the post-swap pointers keep their capabilities.
	xchgq	%rsi, %rdi
	movq	(%rdi), %rax
	movq	%rax, (%rsi)
	ret
	.size	xchg_straight, .-xchg_straight
	.section	.note.GNU-stack,"",@progbits
