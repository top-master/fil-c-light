# SM3 (vsm3rnds2/vsm3msg1/vsm3msg2) and SM4 (vsm4key4/vsm4rnds4): clang and
# binutils spell them vsm3*/vsm4* (VEX.128); OpenSSL's sm3-/sm4-x86_64.pl use
# them. gas before 2.42 does not know them, so sarcasm emits them as .byte
# (x86_64_render BYTE_EMIT; encodings verified against objdump 2.42).
# Compile-only: this host has no SM3/SM4 hardware support.
	.text
	.globl	sm3sm4_ops
	.type	sm3sm4_ops, @function
sm3sm4_ops:                     ;! void(ptr)
	endbr64
	movdqu	(%rdi), %xmm0
	movdqu	(%rsi), %xmm1
	vsm3rnds2	$2, %xmm1, %xmm6, %xmm7
	vsm3msg1	%xmm2, %xmm9, %xmm8
	vsm3msg2	%xmm1, %xmm9, %xmm8
	vsm4key4	(%rsi), %xmm0, %xmm0
	vsm4rnds4	16(%rsi), %xmm1, %xmm0
	movdqu	%xmm0, (%rdi)
	ret
	.size	sm3sm4_ops, .-sm3sm4_ops
	.section	.note.GNU-stack,"",@progbits
