	.text
	# A pseudo as a vector-instruction operand is rejected: pseudos are GPRs only.
	.globl	pseudo_vec_mix
	.type	pseudo_vec_mix, @function
pseudo_vec_mix:                 ;! long(long)
	endbr64
	movq	%rdi, %fil_a
	movdqu	%fil_a, %xmm0
	movq	%rdi, %rax
	ret
	.size	pseudo_vec_mix, .-pseudo_vec_mix
	.section	.note.GNU-stack,"",@progbits
