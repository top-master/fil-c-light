# `loop` whose back-edge target sits beyond rel8 range: `loop` has ONLY a rel8
# encoding, and the 6 bounds-checked loads in the body (plus the pollcheck at
# the back-edge label) put .Lcount more than 127 bytes away from the loop, so
# the emitted file used to die in gas with "value of ... too large for field of
# 1 byte". Sarcasm now rewrites EVERY loop/jrcxz/jecxz through a rel8-reachable
# trampoline at render time: the original instruction jumps 2 bytes ahead to a
# stub that jmps to the original target (no flag-affecting instruction is
# added, so the fall-through flags are untouched). The back edge here is the
# loop itself, so the pollcheck at .Lcount still preserves physical rcx around
# filc_pollcheck_slow exactly as before. Hardware ground truth (plain as +
# gcc): loopbig(ptr)=66, loopbig_rcx(ptr)=0.
	.text
	.globl	loopbig
	.type	loopbig, @function
loopbig:                        ;! long(ptr)
	endbr64
	movq	$3, %rcx
	xorl	%eax, %eax
.Lcount:
	incl	%eax
	movq	0(%rdi), %rsi
	addq	%rsi, %rax
	movq	8(%rdi), %rsi
	addq	%rsi, %rax
	movq	16(%rdi), %rsi
	addq	%rsi, %rax
	movq	24(%rdi), %rsi
	addq	%rsi, %rax
	movq	32(%rdi), %rsi
	addq	%rsi, %rax
	movq	40(%rdi), %rsi
	addq	%rsi, %rax
	loop	.Lcount
	ret
	.size	loopbig, .-loopbig
	.globl	loopbig_rcx
	.type	loopbig_rcx, @function
loopbig_rcx:                    ;! long(ptr)
	endbr64
	movq	$3, %rcx
	xorl	%esi, %esi
.Ltop:
	addq	0(%rdi), %rsi
	addq	8(%rdi), %rsi
	addq	16(%rdi), %rsi
	addq	24(%rdi), %rsi
	addq	32(%rdi), %rsi
	addq	40(%rdi), %rsi
	loop	.Ltop
	# The modeled decrement must still land in the physical rcx the
	# instruction decrements: 0 after a 3-iteration countdown.
	movq	%rcx, %rax
	ret
	.size	loopbig_rcx, .-loopbig_rcx
	.section	.note.GNU-stack,"",@progbits
