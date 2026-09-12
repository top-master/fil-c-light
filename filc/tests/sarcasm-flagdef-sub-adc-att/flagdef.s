# flagDef must recognize `sub` (and shl/sal/mul/imul) as a full flag write. The
# suffix-strip in x86_64_isa's flagDef used to mangle the normalized base
# mnemonic ("sub" -> "su"), so it reported NO flag write and DCE deleted a
# `subq` whose REGISTER result was dead but whose FLAGS were live — the exact
# x86_64-mont5 reduction shape (`subq %r13,%rbp` feeding `adcq`, where the
# destination is immediately redefined). With the sub gone, adcq reads the
# flag clobbered by the preceding xorq (CF=0) instead of the comparison, so
# the reduction's conditional subtract is silently skipped (off-by-n crypto).
# This function returns (b < a) computed by that carry; the sub's register
# result is dead (rbp is never read again), but its CF is the whole point.
	.text
	.globl	flagdef_sub_adc
	.type	flagdef_sub_adc, @function
flagdef_sub_adc:                ;! long(long,long)
	movq	%rdi, %r13
	movq	%rsi, %rbp
	xorq	%rax, %rax
	subq	%r13, %rbp            # CF = (b < a); rbp's value is dead after this
	adcq	%rax, %rax            # rax = CF (needs the sub's flags, not xorq's)
	ret
	.size	flagdef_sub_adc, .-flagdef_sub_adc
	.section	.note.GNU-stack,"",@progbits
