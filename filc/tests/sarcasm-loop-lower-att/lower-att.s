# GAP-(a) probe (AT&T): a `long(ptr,ptr)` function whose FIRST pointer argument's
# capability lower is delivered in the dense rcx slot (fast-CC argument words:
# rdx = intval, rcx = lower). The loop counter is defined (movq $4, %rcx) while
# arg1's capability lower is still live, and a bounds-checked load through %rdi
# follows the definition: pre-fix the entry unpack COALESCED the lower's web
# into the pinned physical rcx (the IRC's George criterion passed - the lower's
# last use precedes the loop header, so no injected pollcheck's physical-rcx
# def sits inside its live range to constrain the coalesce), and the counter's
# own movq then destroyed the lower - the check read the COUNTER as the
# capability lower and dereferenced [rcx-16] (observed pre-fix: SIGSEGV).
# Post-fix the counter's rcx is exclusive for the whole function: the lower is
# de-precolored into an ordinary web (the entry unpack move copies it out of
# rcx into an allocated register) and the allocator keeps every other web out
# of rcx while a counter web exists.
# Hardware ground truth (plain as + gcc): lowerlive_count(a,b) = a[0] + 4*b[0].
	.text
	.globl	lowerlive_count
	.type	lowerlive_count, @function
lowerlive_count:                ;! long(ptr,ptr)
	endbr64
	movq	$4, %rcx            # counter defined while arg1's capability lower is live
	movq	(%rdi), %rax        # checked load through arg1 AFTER the counter def
	xorl	%r10d, %r10d
.Llower:
	addq	(%rsi), %r10        # checked loads through arg2 inside the loop
	loop	.Llower
	addq	%rax, %r10
	movq	%r10, %rax
	ret
	.size	lowerlive_count, .-lowerlive_count
	.section	.note.GNU-stack,"",@progbits
