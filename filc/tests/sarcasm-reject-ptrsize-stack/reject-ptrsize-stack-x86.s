	.intel_syntax noprefix
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# Regression test: an Intel PTR size annotation that contradicts the
	# ISA-determined memory access width must REJECT, on the stack path too.
	# vmovdqu64 with a zmm source stores 64 bytes; the DWORD PTR (4-byte)
	# annotation is a lie that would under-size the materialized stack slot.
	# (The QWORD PTR GPR accesses anchor the -64(%rbp) slot.)
	push	rbp
	mov	rbp, rsp
	sub	rsp, 64
	mov	QWORD PTR [rbp-64], rdi
	vmovdqu64	DWORD PTR [rbp-64], zmm0
	mov	rax, QWORD PTR [rbp-64]
	leave
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
