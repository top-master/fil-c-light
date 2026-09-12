# Intel-syntax twin of the B1 cross-function-jump dispatcher test.
	.intel_syntax noprefix
	.text
	.globl	sha_dispatch
	.type	sha_dispatch, @function
sha_dispatch:                   ;! long(long,long)
	test	edi, edi
	jnz	sha_variant_avx
	test	esi, esi
	jnz	sha_variant_ssse3
	# base body (fallthrough): a + 2*b
	mov	rax, rsi
	add	rax, rax
	add	rax, rdi
	ret
	.size	sha_dispatch, .-sha_dispatch
	.type	sha_variant_avx, @function
sha_variant_avx:                ;! long(long,long)
	# avx variant: a + 10*b
	imul	rax, rsi, 10
	add	rax, rdi
	ret
	.size	sha_variant_avx, .-sha_variant_avx
	.type	sha_variant_ssse3, @function
sha_variant_ssse3:              ;! long(long,long)
	# ssse3 variant: a*b + 7
	mov	rax, rdi
	imul	rax, rsi
	add	rax, 7
	ret
	.size	sha_variant_ssse3, .-sha_variant_ssse3
	.section	.note.GNU-stack,"",@progbits
