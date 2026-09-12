	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# vstmxcsr is a 4-byte STORE. The buffer is 16 bytes and the store is at
	# offset 14: [14,18) straddles the upper bound. Regression for the
	# isStoreInsn mislabel: the trap message must say "cannot write" (it
	# used to be checked — and reported — as a read).
	vstmxcsr	14(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
