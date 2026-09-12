# {k}-masked ALU memory SOURCE (rsaz-avx512's `vpsubq .Lmask52x4(%rip),%ymm3,
# %ymm3{%k1}`): AVX-512 fault suppression reads the memory operand only for
# lanes whose writemask bit is set, so the mask-aware bounds check (the same
# lane structure as a masked vector load) applies. Merge-masking (no {z})
# preserves the destination's masked-off lanes; {z} zeroes them. Executes for
# real (the host has AVX512; the manifest gates it) — including a masked-off
# lane that is OUT OF BOUNDS, which must not trap.
	.text
	.globl	masked_alu_ops
	.type	masked_alu_ops, @function
masked_alu_ops:                 ;! void(ptr,long)
	endbr64
	kmovw	%esi, %k1
	vmovdqu	(%rdi), %ymm3
	vmovdqu	32(%rdi), %ymm4
	# masked qword subtract: enabled lanes subtract, the rest keep the dest
	vpsubq	32(%rdi), %ymm3, %ymm3{%k1}
	# masked qword xor with {z}: enabled lanes xor, the rest are zeroed
	vpxorq	(%rdi), %ymm4, %ymm4{%k1}{z}
	vmovdqu	%ymm3, (%rdi)
	vmovdqu	%ymm4, 32(%rdi)
	ret
	.size	masked_alu_ops, .-masked_alu_ops

	# A masked-off lane may be out of bounds: the object is 5 qwords (40
	# bytes), the vpsubq memory source at 32(%rdi) spans 4 qwords (q4..q7),
	# so lanes 1-3 are out of bounds — with mask 0001 only lane 0 is read.
	.globl	masked_alu_oob
	.type	masked_alu_oob, @function
masked_alu_oob:                 ;! void(ptr)
	endbr64
	movl	$1, %eax
	kmovw	%eax, %k1
	vmovdqu	(%rdi), %ymm3
	vpsubq	32(%rdi), %ymm3, %ymm3{%k1}
	vmovdqu	%ymm3, (%rdi)
	ret
	.size	masked_alu_oob, .-masked_alu_oob
	.section	.note.GNU-stack,"",@progbits
