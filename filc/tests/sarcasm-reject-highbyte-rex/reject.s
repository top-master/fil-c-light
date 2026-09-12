# A byte register other than %al/%cl/%dl/%bl (%spl/%bpl/%sil/%dil and %r8b+)
# requires a REX prefix, which a high-byte register cannot combine with.
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	movb	%ah, %sil
	movl	%esi, %eax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
