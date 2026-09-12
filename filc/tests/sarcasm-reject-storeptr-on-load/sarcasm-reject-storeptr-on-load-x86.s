	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# `;! store ptr` on a LOAD: the invisicap store would silently replace
	# the load (a miscompile) — reject cleanly.
	movq	(%rdi), %rsi    ;! store ptr
	movq	%rsi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
