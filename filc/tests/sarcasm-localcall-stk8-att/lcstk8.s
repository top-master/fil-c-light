# The rsaz +8 shape: the caller builds a fixed alloca region and calls a local
# subroutine that takes the buffer address with `leaq 8(%rsp), %rdi`, writes
# results through it, and reads a caller slot through `128+8(%rsp)` — the
# return-address-compensated convention. Under the no-push clone model the
# clone's rsp-relative displacements are biased by -8 at clone time, so the
# sub's `8(%rsp)` keys to the caller's region offset 0 and the lea becomes
# `leaq 0(%rsp)`, which the region redirect resolves to the region pointer.
	.text
	.globl	rsaz_like
	.type	rsaz_like, @function
rsaz_like:                      ;! long(long)
	pushq	%rbx
	subq	$128+24, %rsp
	movq	%rsp, %rbx          ;! alloca result size=152
	movq	%rdi, 128(%rsp)     # the rsaz saved-carry slot
	movq	$3, %r10            # multiplier (custom convention)
	call	__mul64x
	movq	0(%rsp), %rax       # sum the buffer the sub wrote
	addq	8(%rsp), %rax
	addq	16(%rsp), %rax
	addq	24(%rsp), %rax
	addq	32(%rsp), %rax
	addq	40(%rsp), %rax
	addq	48(%rsp), %rax
	addq	56(%rsp), %rax
	addq	$128+24, %rsp
	popq	%rbx
	ret
	.size	rsaz_like, .-rsaz_like
	.type	__mul64x, @function
__mul64x:
	leaq	8(%rsp), %rdi       # +8 rule: caller's buffer base (region offset 0)
	movq	128+8(%rsp), %rsi   # +8 rule: caller's 128(%rsp) saved slot
	imulq	%r10, %rsi
	movq	%rsi, (%rdi)
	movq	%rsi, 8(%rdi)
	movq	%rsi, 16(%rdi)
	movq	%rsi, 24(%rdi)
	movq	%rsi, 32(%rdi)
	movq	%rsi, 40(%rdi)
	movq	%rsi, 48(%rdi)
	movq	%rsi, 56(%rdi)
	ret
	.size	__mul64x, .-__mul64x
	.section	.note.GNU-stack,"",@progbits
