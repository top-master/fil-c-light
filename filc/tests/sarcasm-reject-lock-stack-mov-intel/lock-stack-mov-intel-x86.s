	.intel_syntax noprefix
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# Intel-syntax twin of sarcasm-reject-lock-stack-mov: `lock` on a
	# stack-frame access is rejected (the slot virtualizes/materializes
	# before classify's lockAllows check, so the prefix would be silently
	# elided; a thread-confined slot has no use for `lock`).
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	lock mov	QWORD PTR -8[rbp], rdi
	mov	rax, QWORD PTR -8[rbp]
	leave
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
