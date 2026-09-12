	.text
	# `.alloca` consolidates alignment: the result already satisfies the
	# requested alignment, so call sites use it directly — no per-site
	# `and $-16` masking (and no `and $8` / `xor $8` rounding dances) is
	# needed for aligned vector traffic. An `and $-16` on the result is a
	# value no-op that also preserves the capability (see sarcasm-and-cap).
	.globl	alignuse_direct
	.type	alignuse_direct, @function
alignuse_direct:                ;! long(long)
	endbr64
	.alloca $64, $16, %rax
	movq	%rdi, (%rax)
	movq	%rdi, 8(%rax)
	movdqa	(%rax), %xmm0       # aligned vector traffic, no prior masking
	movdqa	%xmm0, 16(%rax)
	movdqa	%xmm0, 32(%rax)
	movdqa	16(%rax), %xmm1
	movq	%xmm1, %rcx
	addq	32(%rax), %rcx
	movq	%rcx, %rax
	ret
	.size	alignuse_direct, .-alignuse_direct
	.globl	alignuse_and16
	.type	alignuse_and16, @function
	# The old per-site idiom (`and $-16` before vector traffic) still works:
	# the mask is a no-op on the already-aligned value and keeps the cap.
alignuse_and16:                 ;! long(long)
	endbr64
	.alloca $64, $16, %rax
	andq	$-16, %rax
	movq	%rdi, (%rax)
	movdqa	(%rax), %xmm0
	movdqa	%xmm0, 16(%rax)
	movq	16(%rax), %rax
	ret
	.size	alignuse_and16, .-alignuse_and16
	.globl	alignuse_dyn
	.type	alignuse_dyn, @function
	# Dynamic size with static alignment: still 16-aligned, directly usable.
alignuse_dyn:                   ;! ptr(long)
	endbr64
	leaq	32(,%rdi,8), %rcx
	.alloca %rcx, $16, %rax
	ret
	.size	alignuse_dyn, .-alignuse_dyn
	.globl	alignuse_a32
	.type	alignuse_a32, @function
	# Wider alignment is satisfied too: direct 32-byte vector traffic.
alignuse_a32:                   ;! ptr()
	endbr64
	.alloca $64, $32, %rax
	vmovdqu	%ymm0, (%rax)
	ret
	.size	alignuse_a32, .-alignuse_a32
	.section	.note.GNU-stack,"",@progbits
