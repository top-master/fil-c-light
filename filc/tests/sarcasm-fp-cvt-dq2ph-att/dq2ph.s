	.text
	.globl	cvt_pd2uqq
	.type	cvt_pd2uqq, @function
cvt_pd2uqq:                     ;! void(ptr, ptr)
	# vcvtpd2uqq zmm, m512: full-width unsigned convert (8-byte elements
	# on both sides, like vcvtpd2qq), 64-byte memory source filling the
	# 64-byte input object exactly. rdi -> 64-byte object holding eight
	# doubles; rsi -> u64[8] out.
	vcvtpd2uqq	(%rdi), %zmm0
	vmovdqu64	%zmm0, (%rsi)
	ret
	.size	cvt_pd2uqq, .-cvt_pd2uqq
	.globl	cvt_tpd2uqq
	.type	cvt_tpd2uqq, @function
cvt_tpd2uqq:                    ;! void(ptr, ptr)
	# vcvttpd2uqq zmm, m512: truncation twin, same 64-byte full width.
	vcvttpd2uqq	(%rdi), %zmm1
	vmovdqu64	%zmm1, (%rsi)
	ret
	.size	cvt_tpd2uqq, .-cvt_tpd2uqq

	# The vcvtdq2ph/vcvtudq2ph functions below assemble ALWAYS (proving
	# sarcasm accepts the m512-source bare-ymm form with a 64-byte check,
	# and the x/y source suffixes at 16/32 bytes — the fix), but main.c
	# only CALLS them when CPUID reports AVX512-FP16: the converts are
	# AVX512-FP16 instructions and #UD otherwise. The 64-byte bare-form
	# width is additionally proven behaviorally, without needing FP16
	# silicon, by sarcasm-fp-oob-dq2ph-att (the bounds check fires before
	# the instruction would execute).
	.globl	dq2ph_att
	.type	dq2ph_att, @function
dq2ph_att:                      ;! void(ptr, ptr)
	# Bare vcvtdq2ph with a ymm destination: unambiguous m512 source (the
	# .512 form has no z-suffixed spelling), 64 bytes. rdi -> int32[16];
	# rsi -> uint16[16] out.
	vcvtdq2ph	(%rdi), %ymm0
	vmovdqu	%ymm0, (%rsi)
	ret
	.size	dq2ph_att, .-dq2ph_att
	.globl	udq2ph_att
	.type	udq2ph_att, @function
udq2ph_att:                     ;! void(ptr, ptr)
	# vcvtudq2ph twin (unsigned source dwords), same 64-byte m512 source.
	vcvtudq2ph	(%rdi), %ymm1
	vmovdqu	%ymm1, (%rsi)
	ret
	.size	udq2ph_att, .-udq2ph_att
	.globl	dq2ph_x_att
	.type	dq2ph_x_att, @function
dq2ph_x_att:                    ;! void(ptr, ptr)
	# x source suffix: m128 source (16 bytes) -> xmm dest (4 halfs in the
	# low 8 bytes, the rest zeroed). rdi -> int32[4]; rsi -> uint16[8].
	vcvtdq2phx	(%rdi), %xmm2
	vmovdqu	%xmm2, (%rsi)
	ret
	.size	dq2ph_x_att, .-dq2ph_x_att
	.globl	dq2ph_y_att
	.type	dq2ph_y_att, @function
dq2ph_y_att:                    ;! void(ptr, ptr)
	# y source suffix: m256 source (32 bytes) -> xmm dest (8 halfs).
	# rdi -> int32[8]; rsi -> uint16[8].
	vcvtdq2phy	(%rdi), %xmm3
	vmovdqu	%xmm3, (%rsi)
	ret
	.size	dq2ph_y_att, .-dq2ph_y_att
	.globl	udq2ph_x_att
	.type	udq2ph_x_att, @function
udq2ph_x_att:                   ;! void(ptr, ptr)
	vcvtudq2phx	(%rdi), %xmm4
	vmovdqu	%xmm4, (%rsi)
	ret
	.size	udq2ph_x_att, .-udq2ph_x_att
	.globl	udq2ph_y_att
	.type	udq2ph_y_att, @function
udq2ph_y_att:                   ;! void(ptr, ptr)
	vcvtudq2phy	(%rdi), %xmm5
	vmovdqu	%xmm5, (%rsi)
	ret
	.size	udq2ph_y_att, .-udq2ph_y_att
	.section	.note.GNU-stack,"",@progbits
