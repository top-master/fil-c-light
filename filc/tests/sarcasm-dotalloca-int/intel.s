	.intel_syntax noprefix
	.text
	# `.alloca` in Intel-syntax files, including a frame-relative spill slot.
	.globl	dotalloca_intel
	.type	dotalloca_intel, @function
dotalloca_intel:                ;! long(long)
	endbr64
	.alloca 40, 32, rax
	mov	QWORD PTR [rax], rdi
	mov	rax, QWORD PTR [rax]
	ret
	.size	dotalloca_intel, .-dotalloca_intel
	.globl	dotalloca_intel_slot
	.type	dotalloca_intel_slot, @function
dotalloca_intel_slot:           ;! long(long)
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	mov	QWORD PTR [rbp - 8], rdi
	.alloca [rbp - 8], 16, rax
	mov	QWORD PTR [rax], rdi
	mov	rax, QWORD PTR [rax]
	add	rsp, 16
	pop	rbp
	ret
	.size	dotalloca_intel_slot, .-dotalloca_intel_slot
	.section	.note.GNU-stack,"",@progbits
