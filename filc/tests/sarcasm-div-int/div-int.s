	.intel_syntax noprefix
	.text
	.globl	idiv_mem_int
	.type	idiv_mem_int, @function
idiv_mem_int:                   ;! void(ptr, ptr)
	# Intel-syntax memory-form signed division: the QWORD PTR operand renders
	# as idivq via suffix synthesis. rdi = io ([0]=dividend in, [1]=quotient
	# out, [2]=remainder out); rsi points at a 16-byte object whose LAST 8
	# bytes hold the divisor (checked 8-byte access at offset 8).
	mov	rax, QWORD PTR [rdi]
	cqo
	idiv	QWORD PTR [rsi+8]
	mov	QWORD PTR [rdi+8], rax
	mov	QWORD PTR [rdi+16], rdx
	ret
	.size	idiv_mem_int, .-idiv_mem_int

	.globl	idiv_reg_int
	.type	idiv_reg_int, @function
idiv_reg_int:                   ;! long(ptr, ptr)
	# Register-form signed division with webs live across cqo/idiv, Intel
	# syntax. rdi = in ([0]=dividend, [1]=divisor); rsi = out ([0]=quotient,
	# [1]=remainder). Returns a checksum of the live-across values.
	mov	rax, QWORD PTR [rdi]
	mov	rcx, QWORD PTR [rdi+8]
	mov	r8, 7
	mov	r9, 70
	mov	r10, 700
	mov	r11, 7000
	cqo
	idiv	rcx
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rsi+8], rdx
	lea	rax, [r8+r9]
	add	rax, r10
	add	rax, r11
	ret
	.size	idiv_reg_int, .-idiv_reg_int
	.section	.note.GNU-stack,"",@progbits
