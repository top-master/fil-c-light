	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# `;! load ptr` on a STORE: the invisicap load would silently replace
	# the store (a miscompile) — reject cleanly.
	movq	%rsi, (%rdi)    ;! load ptr
	movq	%rsi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
