	.text
	# save/restore capability through pseudoregisters: the capability is saved
	# off a pseudo-held pointer, killed, and restored onto a later ALU op.
	.globl	pseudo_save_restore
	.type	pseudo_save_restore, @function
pseudo_save_restore:            ;! long(ptr)
	endbr64
	movq	%rdi, %fil_p
	movq	%fil_p, %rax  #! save capability (pp)
	movq	(%rax), %rax
	addq	$0, %rax  #! restore capability (pp)
	movq	(%rax), %rax
	ret
	.size	pseudo_save_restore, .-pseudo_save_restore
	.section	.note.GNU-stack,"",@progbits
