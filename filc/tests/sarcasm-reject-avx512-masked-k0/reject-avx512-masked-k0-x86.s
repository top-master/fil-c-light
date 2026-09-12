	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# {%k0} is not a valid writemask (k0 reads as all-ones — gas rejects it
	# too), so a {k0} memory access is rejected cleanly rather than checked
	# as if k0's value were a real mask.
	vmovdqu64	(%rdi), %zmm0{%k0}
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
