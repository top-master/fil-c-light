# A high-byte operand with a MEMORY operand is rejected: the bounds-check
# rewrite addresses memory through an allocated register that may require a
# REX prefix, which a high-byte register cannot combine with. (High-byte
# register-to-register forms are supported — see sarcasm-highbyte-att.)
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	movq	$0x1122334455667788, %rax
	movb	%ah, (%rdi)
	movl	$0, %eax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
