# B1 cross-function jump to an EXTERN symbol carrying an inline signature
# annotation (the ossl_bsaes_cbc_encrypt `jne asm_AES_cbc_encrypt` shape): the
# jump becomes an annotated call to the C function plus an epilogue jump.
	.text
	.globl	maybe_cubed
	.type	maybe_cubed, @function
maybe_cubed:                    ;! long(long)
	testl	%edi, %edi
	jne	c_cube              #! long(long)
	# fallthrough: 2*x + 1
	movq	%rdi, %rax
	addq	%rax, %rax
	addq	$1, %rax
	ret
	.size	maybe_cubed, .-maybe_cubed
	.section	.note.GNU-stack,"",@progbits
