# The CET `notrack` prefix changes indirect-branch tracking for the
# instruction that follows; the parser used to treat it as a mnemonic whose
# operand was a bare symbol ("jmp *%rax" as one token) and died on the
# misleading "memory access with a symbolic address" error. It must be a clean
# rejection with its own message.
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	endbr64
	movq	%rdi, %rax
	notrack	jmp	*%rax
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
