# movzbq with a high-byte source is not encodable: the 64-bit destination
# requires a REX.W prefix, which a high-byte register cannot combine with
# (movzbl/movzbw are the supported forms).
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	movq	$0x1122334455667788, %rax
	movzbq	%ah, %rdx
	movq	%rdx, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
