	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# cmpxchg8b cannot operate on pointers: an invisicap is a (intval, lower)
	# pair whose update cannot be synthesized from a double-width CAS. Every
	# ptr-family annotation on it is rejected (the cmpxchg16b case is covered
	# by sarcasm-reject-cmpxchg16b-ptr; this is the 8-byte twin — shared
	# rejection path).
	movq	$1, %rax
	movq	$2, %rdx
	movq	$3, %rbx
	movq	$4, %rcx
	cmpxchg8b	(%rdi)          ;! atomic ptr
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
