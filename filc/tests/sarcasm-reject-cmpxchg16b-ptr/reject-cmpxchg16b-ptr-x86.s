	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# cmpxchg16b cannot operate on pointers: an invisicap is a (intval, lower)
	# pair whose update cannot be synthesized from a double-width CAS. Every
	# ptr-family annotation on it is rejected.
	cmpxchg16b	(%rdi)          ;! atomic ptr
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
