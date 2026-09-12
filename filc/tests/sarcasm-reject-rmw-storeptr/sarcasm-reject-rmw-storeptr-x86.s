	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# `;! store ptr` on a memory-destination RMW: an invisicap store cannot
	# express a read-modify-write — reject (pointer RMWs need `;! load store ptr`).
	addq	%rsi, (%rdi)    ;! store ptr
	movq	%rsi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
