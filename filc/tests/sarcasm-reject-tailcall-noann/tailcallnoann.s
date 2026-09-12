	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	endbr64
	movq	%rdi, %rax
	# An UNANNOTATED jump to an extern symbol is a tail call with no signature
	# to marshal against: it keeps the plain rejection (only annotated jumps
	# and jumps to same-file signatured entries are converted to calls).
	jmp	somefunc
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
