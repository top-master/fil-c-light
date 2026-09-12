# An extern rip-relative access with no `#! global ptr` annotation: sarcasm
# cannot invent a capability for a symbol it does not define, so this is a
# clean compile-time rejection (the message points at the annotation).
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	movq	g(%rip), %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
