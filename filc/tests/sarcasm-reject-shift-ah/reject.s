# A shift/rotate count can only come from %cl — the only register-count
# encoding in the ISA — so a high-byte register can never encode it.
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	shlb	%ah, %cl
	movl	%ecx, %eax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
