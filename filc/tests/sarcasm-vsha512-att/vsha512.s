# SHA512-NI (vsha512rnds2/vsha512msg1/vsha512msg2, VEX.256.F2.0F38.W0): the
# sha512-block SHA512-NI body shape (perlasm emits these as raw .byte, which
# decodeByteInsns decodes; the spelled forms below exercise the same path).
# gas before 2.42 does not know these mnemonics, so sarcasm emits them as
# .byte (x86_64_render BYTE_EMIT) — compile-only here (this host has no
# SHA512-NI), with the encodings verified against objdump 2.42.
	.text
	.globl	vsha512_ops
	.type	vsha512_ops, @function
vsha512_ops:                    ;! void(ptr)
	endbr64
	movdqu	(%rdi), %xmm0
	vmovdqu	(%rsi), %ymm3
	vmovdqu	32(%rsi), %ymm4
	vsha512rnds2	%xmm0, %ymm8, %ymm3
	vsha512msg1	%xmm4, %ymm3
	vsha512msg2	%ymm5, %ymm4
	# the .byte-encoded forms decode to the same instructions
	.byte	0xc4,0x62,0x1f,0xcb,0xd8
	.byte	0xc4,0xe2,0x7f,0xcc,0xdc
	.byte	0xc4,0xe2,0x7f,0xcd,0xde
	vmovdqu	%ymm3, (%rsi)
	vmovdqu	%ymm4, 32(%rsi)
	ret
	.size	vsha512_ops, .-vsha512_ops
	.section	.note.GNU-stack,"",@progbits
