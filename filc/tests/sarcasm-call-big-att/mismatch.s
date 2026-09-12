# Signature-mismatch generic (buffer-CC) path with an 11-word callsite
# signature: cread is not defined in this module, so the direct call resolves
# through the weak pizlonatedFI<sig>_cread callsite thunk. The callsite declares
# cread long(ptr,ptr,ptr,ptr,ptr,int) but cread is really long(ptr), so the
# thunk's signature check misses and it takes the generic buffer-CC path —
# marshalling all eleven argument words (the register-resident ones from its
# hold pool, the stack-resident ones read back from the incoming stack area)
# into my_thread's CC buffer.
	.text
	.globl	callcread
	.type	callcread, @function
callcread:                      #! long(ptr)
	movq	%rdi, %rax
	movq	%rax, %rsi
	movq	%rax, %rdx
	movq	%rax, %rcx
	movq	%rax, %r8
	movl	$9, %r9d
	call	cread ;! long(ptr,ptr,ptr,ptr,ptr,int)
	ret
	.size	callcread, .-callcread
	.section	.note.GNU-stack,"",@progbits
