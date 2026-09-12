	.text
	.globl	flaglahf
	.type	flaglahf, @function
flaglahf:                       ;! long(ptr)
	stc
	movq	(%rdi), %rcx
	lahf
	# AH = SF:ZF:0:AF:0:PF:1:CF — CF is bit 0 of AH, i.e. bits 8-15 of the rax
	# web hold the flag byte: shift it down and mask bit 0.
	shrq	$8, %rax
	andq	$1, %rax
	ret
	.size	flaglahf, .-flaglahf
	.section	.note.GNU-stack,"",@progbits
