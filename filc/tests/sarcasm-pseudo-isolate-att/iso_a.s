	.text
	# Per-file pseudo isolation: this file and iso_b.s use the SAME pseudo
	# names (`%fil_tmp`, `%fil_acc`), and each file numbers its own pseudos
	# independently from the dedicated band. pseudo_iso_a returns 2*a.
	.globl	pseudo_iso_a
	.type	pseudo_iso_a, @function
pseudo_iso_a:                   ;! long(long)
	endbr64
	movq	%rdi, %fil_tmp
	movq	%rdi, %fil_acc
	addq	%fil_tmp, %fil_acc
	movq	%fil_acc, %rax
	ret
	.size	pseudo_iso_a, .-pseudo_iso_a
	.section	.note.GNU-stack,"",@progbits
