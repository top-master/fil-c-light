	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	foo
	.type	foo, @function
foo:                            ;! int(ptr, int)
	endbr64
	sub	rsp, 8
	# foo receives a pointer to a function pointer: load the callee with an
	# annotated pointer load (the migration for memory-operand calls), then
	# call the loaded function-pointer value.
	mov	rax, QWORD PTR [rdi] ;! load ptr
	lea	edi, [rsi + 1]
	call	rax ;! ptr(int)
	mov	eax, DWORD PTR [rax]
	add	rsp, 8
	add	eax, 67
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
