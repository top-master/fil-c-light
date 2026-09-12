# A `#!` annotation body must still be a known annotation: this one is bogus.
	.text
	.globl	f
	.type	f, @function
f:	#! void(ptr)
	movq	%rax, %rbx #! bogus annotation
	ret
	.size	f, .-f
