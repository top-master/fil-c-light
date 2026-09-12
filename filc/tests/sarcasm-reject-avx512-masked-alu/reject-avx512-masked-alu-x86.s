	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# {k}-masked ALU memory sources whose lane structure sarcasm models (the
	# natural element granularity of the operation) are now SUPPORTED — see
	# sarcasm-masked-alu-att. But {%k0} is never a valid writemask on a memory
	# access (k0 reads as all-ones; gas rejects it too), so it stays rejected.
	vaddps	(%rdi), %zmm0, %zmm1{%k0}
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
