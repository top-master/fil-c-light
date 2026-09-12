# The .Lenc_loop8_enter shape (aesni-x86_64): a call to a label in the MIDDLE
# of a subroutine whose reachable region contains a backward branch to a label
# BEFORE the entry (the loop head). The clone must contain the whole loop
# structure (the reachable region from the mid-label, in source order), not
# just [mid-label .. ret]. Convention: %r10 = rounds left, %r11 = step,
# %r9 = accumulator (persists across the mid-label call).
	.text
	.globl	midloop_like
	.type	midloop_like, @function
midloop_like:                   ;! long(long)
	movq	%rdi, %r10
	movq	%rdi, %r11
	call	_loop8              # full entry: init + loop
	movq	%r9, %rbx
	movl	$2, %r10d
	call	.Lloop8_enter       # mid-label entry: skips the init (acc persists)
	leaq	(%rbx,%r9), %rax
	ret
	.size	midloop_like, .-midloop_like
	.type	_loop8, @function
_loop8:
	xorl	%r9d, %r9d          # acc = 0 (skipped by the mid-label entry)
	jmp	.Linner8
	.align	16
.Lloop8:
	addq	$100, %r9           # loop-head round (BEFORE the mid-label entry)
.Linner8:
	addq	%r11, %r9           # inner round
.Lloop8_enter:
	addq	$1, %r9             # enter round
	subq	$1, %r10
	jnz	.Lloop8             # backward branch to the pre-entry loop head
	addq	$7, %r9             # final round
	ret
	.size	_loop8, .-_loop8
	.section	.note.GNU-stack,"",@progbits
