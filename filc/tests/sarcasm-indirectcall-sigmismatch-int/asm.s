	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	foo
	.type	foo, @function
foo:                            ;! int(ptr, int)
	endbr64
	sub	rsp, 8
	mov	rax, rdi
	mov	edi, esi
	# The callsite declares the callee int(ptr) but main.c's bar is really
	# int(int): the signature numbers differ, so the runtime dispatch takes
	# the inlined generic buffer-CC path (not the fast path) and the call
	# still returns the right answer.
	call	rax ;! int(ptr)
	add	rsp, 8
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
