	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	endbr64
	movq	%rdi, %rax
	# A memory-indirect branch (`jmp *(%rax)`, e.g. a jump through a function
	# pointer stored in memory) has no provable target: the renderer would pass
	# it through verbatim as an uncontrolled branch. Rejected by the same
	# indirect-branch check as the register form (`jmp *%rax`) and exactly like
	# arm64's `br xN` / `b xN`.
	jmp	*(%rax)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
