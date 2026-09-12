	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	subq	%rsi, %rsp   ;! alloca size (a)
	subq	%rsi, %rsp   ;! alloca size (a)
	movq	%rsp, %rax   ;! alloca result (a)
	ret
	.size	f, .-f
