	.text
	.globl	ifma52
	.type	ifma52, @function
ifma52:                         ;! void(ptr, ptr)
	# rdi -> 192-byte io buffer: [0,64) lo accumulator seed/result,
	# [64,128) hi accumulator seed/result, [128,192) multiplicand b.
	# rsi -> 64-byte object holding the 8 multiplicands a: the vpmadd52*
	# memory source ends EXACTLY at the object end (an over-wide check
	# would trap; before the AVX512-IFMA entries were added these
	# mnemonics were unknown to sarcasm and rejected outright — the digits
	# keep them out of the p-family pattern).
	vmovdqu64	128(%rdi), %zmm1
	vmovdqu64	(%rdi), %zmm0
	vmovdqu64	64(%rdi), %zmm2
	vpmadd52luq	(%rsi), %zmm1, %zmm0
	vpmadd52huq	(%rsi), %zmm1, %zmm2
	vmovdqu64	%zmm0, (%rdi)
	vmovdqu64	%zmm2, 64(%rdi)
	ret
	.size	ifma52, .-ifma52
	.section	.note.GNU-stack,"",@progbits
