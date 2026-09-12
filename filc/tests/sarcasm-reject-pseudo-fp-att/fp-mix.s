	.text
	# A pseudo flowing into a vector register is rejected: pseudos are GPRs only.
	.globl	pseudo_fp_mix
	.type	pseudo_fp_mix, @function
pseudo_fp_mix:                  ;! long(long)
	endbr64
	movq	%rdi, %fil_a
	movq	%fil_a, %xmm0
	movq	%rdi, %rax
	ret
	.size	pseudo_fp_mix, .-pseudo_fp_mix
	.section	.note.GNU-stack,"",@progbits
