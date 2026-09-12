# Cross-function jumps (B1): a dispatcher capability-checks and tail-branches
# to same-file signature-annotated variant bodies (the sha1_block_data_order
# dispatch shape): `jnz variant` / `jmp variant2` each become an annotated call
# plus a jump to the dispatcher's epilogue; the base body is the fallthrough.
	.text
	.globl	sha_dispatch
	.type	sha_dispatch, @function
sha_dispatch:                   ;! long(long,long)
	testl	%edi, %edi
	jnz	sha_variant_avx
	testl	%esi, %esi
	jnz	sha_variant_ssse3
	# base body (fallthrough): a + 2*b
	movq	%rsi, %rax
	addq	%rax, %rax
	addq	%rdi, %rax
	ret
	.size	sha_dispatch, .-sha_dispatch
	.type	sha_variant_avx, @function
sha_variant_avx:                ;! long(long,long)
	# avx variant: a + 10*b
	imulq	$10, %rsi, %rax
	addq	%rdi, %rax
	ret
	.size	sha_variant_avx, .-sha_variant_avx
	.type	sha_variant_ssse3, @function
sha_variant_ssse3:              ;! long(long,long)
	# ssse3 variant: a*b + 7
	movq	%rdi, %rax
	imulq	%rsi, %rax
	addq	$7, %rax
	ret
	.size	sha_variant_ssse3, .-sha_variant_ssse3
	.section	.note.GNU-stack,"",@progbits
