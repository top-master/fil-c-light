# Taking the address of the stack frame and RETURNING it: the parked stack
# address would escape as the return value -- the one carrier read that can
# never be dropped. (An unused saved-rsp carrier is harmless and accepted --
# the value is phantom; every usable read of it, like this return, rejects.)
	.text
	.globl	f
	.type	f, @function
f:                              ;! ptr(void)
	pushq	%rbp
	movq	%rsp, %rbp
	leaq	8(%rsp), %rax
	popq	%rbp
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
