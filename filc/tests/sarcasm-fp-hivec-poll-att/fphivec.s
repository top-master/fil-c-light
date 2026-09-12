# Injected runtime calls (pollchecks, allocations) must save/restore vector
# registers 16-31 and opmask k0-7, not just xmm0-15: the Fil-C runtime's
# libyolocimpl.so has EVEX-compiled string/memory routines that clobber
# ymm/zmm16-31 and k0-7 as caller-saved scratch. When a loop-header pollcheck
# fires, the slow path runs that EVEX code and destroys live ymm16-18
# (rsaz_1024_amm52x30_x2's channel-2 accumulators — a nondeterministic
# wrong-result where only the ymm16-18 half was clobbered). This loop keeps
# ymm16-18 accumulators live across the pollcheck; they must survive.
	.text
	.globl	fp_hivec_poll
	.type	fp_hivec_poll, @function
fp_hivec_poll:                  ;! void(ptr,ptr,long)
	vpxord	%ymm16, %ymm16, %ymm16
	vpxord	%ymm17, %ymm17, %ymm17
	vpxord	%ymm18, %ymm18, %ymm18
	movq	%rdx, %rcx
.Lloop:
	vpaddq	(%rsi), %ymm16, %ymm16
	vpaddq	32(%rsi), %ymm17, %ymm17
	vpaddq	64(%rsi), %ymm18, %ymm18
	subq	$1, %rcx
	jnz	.Lloop
	vmovdqu64	%ymm16, (%rdi)
	vmovdqu64	%ymm17, 32(%rdi)
	vmovdqu64	%ymm18, 64(%rdi)
	ret
	.size	fp_hivec_poll, .-fp_hivec_poll
	.section	.note.GNU-stack,"",@progbits
