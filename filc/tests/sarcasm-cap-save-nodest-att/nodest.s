# `save capability` on an instruction with no register destination (a store)
# is a compile error.
	.text
	.globl	cap_nodest
	.type	cap_nodest, @function
cap_nodest:                     ;! void(ptr, ptr)
	endbr64
	movq	%rdi, (%rsi)  #! save capability (v)
	ret
	.size	cap_nodest, .-cap_nodest
	.section	.note.GNU-stack,"",@progbits
