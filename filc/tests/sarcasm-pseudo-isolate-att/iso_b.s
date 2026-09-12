	.text
	# Per-file pseudo isolation: same pseudo names as iso_a.s (`%fil_tmp`,
	# `%fil_acc`), numbered independently in this file. pseudo_iso_b
	# returns 2*b + 5.
	.globl	pseudo_iso_b
	.type	pseudo_iso_b, @function
pseudo_iso_b:                   ;! long(long)
	endbr64
	movq	%rdi, %fil_tmp
	movq	$5, %fil_acc
	addq	%fil_tmp, %fil_acc
	addq	%fil_tmp, %fil_acc
	movq	%fil_acc, %rax
	ret
	.size	pseudo_iso_b, .-pseudo_iso_b
	.section	.note.GNU-stack,"",@progbits
