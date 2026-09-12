	.text
	// A pseudo flowing into a NEON register is rejected: pseudos are GPRs only.
	.globl	pseudo_fp_mix
	.type	pseudo_fp_mix, @function
pseudo_fp_mix:                  //! long(long)
	fmov	d0, fil_a
	mov	x0, x0
	ret
	.size	pseudo_fp_mix, .-pseudo_fp_mix
