	.intel_syntax noprefix
	.text
	.globl	f
	.type	f, @function
f:                              ;! long()
	# Intel-syntax twin of sarcasm-reject-lock-stack-add: `lock add` on a
	# stack slot is rejected (the virtualized slot would silently drop the
	# prefix, turning a locked memory RMW into an unlocked register RMW).
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	mov	QWORD PTR -8[rbp], 0
	lock add	QWORD PTR -8[rbp], 1
	mov	rax, QWORD PTR -8[rbp]
	leave
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
