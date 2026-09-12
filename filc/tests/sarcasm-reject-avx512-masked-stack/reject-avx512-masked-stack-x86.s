	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# AVX512 {k}-masked memory accesses cannot be bounds-checked (masked-off
	# lanes may not touch memory). This is the stack-slot path twin of the
	# heap masked-access reject tests: the frame rewrite runs first, so the
	# rejection must fire there too.
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	vmovdqu32	%zmm0, -64(%rbp){%k1}
	movq	%rdi, %rax
	leave
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
