	.text
	# Register pressure: more simultaneously-live pseudos than physical GPRs
	# forces the allocator to spill some to the stack and reload them. The
	# SysV stack arguments (7th and later) are read at entry %rsp, before any
	# pushes.
	.globl	pseudo_spill
	.type	pseudo_spill, @function
pseudo_spill:                   ;! long(long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long)
	endbr64
	movq	8(%rsp), %fil_p06
	movq	16(%rsp), %fil_p07
	movq	24(%rsp), %fil_p08
	movq	32(%rsp), %fil_p09
	movq	40(%rsp), %fil_p10
	movq	48(%rsp), %fil_p11
	movq	56(%rsp), %fil_p12
	movq	64(%rsp), %fil_p13
	movq	72(%rsp), %fil_p14
	movq	80(%rsp), %fil_p15
	movq	%rdi, %fil_p00
	movq	%rsi, %fil_p01
	movq	%rdx, %fil_p02
	movq	%rcx, %fil_p03
	movq	%r8, %fil_p04
	movq	%r9, %fil_p05
	addq	%fil_p01, %fil_p00
	addq	%fil_p02, %fil_p00
	addq	%fil_p03, %fil_p00
	addq	%fil_p04, %fil_p00
	addq	%fil_p05, %fil_p00
	addq	%fil_p06, %fil_p00
	addq	%fil_p07, %fil_p00
	addq	%fil_p08, %fil_p00
	addq	%fil_p09, %fil_p00
	addq	%fil_p10, %fil_p00
	addq	%fil_p11, %fil_p00
	addq	%fil_p12, %fil_p00
	addq	%fil_p13, %fil_p00
	addq	%fil_p14, %fil_p00
	addq	%fil_p15, %fil_p00
	movq	%fil_p00, %rax
	ret
	.size	pseudo_spill, .-pseudo_spill
	.section	.note.GNU-stack,"",@progbits
