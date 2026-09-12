	.text
	.globl	perm_t2d
	.type	perm_t2d, @function
perm_t2d:                       ;! long(ptr)
	# vpermt2d with a 64-byte memory source operand (checked at full vector
	# width; the load at offset 128 spans the last 64 bytes of the object, so
	# a wider check would trap). struct { uint32_t idx[16]; uint32_t a[16];
	# uint32_t b[16]; } — result lane i = idx[i] < 16 ? a[idx[i]] :
	# b[idx[i] - 16], stored back over a.
	vmovdqu64	(%rdi), %zmm0
	vmovdqu64	64(%rdi), %zmm1
	vpermt2d	128(%rdi), %zmm0, %zmm1
	vmovdqu64	%zmm1, 64(%rdi)
	xorl	%eax, %eax
	ret
	.size	perm_t2d, .-perm_t2d
	.globl	compress_expand
	.type	compress_expand, @function
compress_expand:                ;! long(ptr, ptr)
	# Unmasked expand/compress round-trip through a stack slot: vpcompressd
	# stores ALL 16 dwords contiguously (64 bytes), vpexpandd loads them back.
	# (Masked forms still reject via the generic {k} rule.)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	vmovdqu64	(%rdi), %zmm0
	vpcompressd	%zmm0, -64(%rbp)
	vpexpandd	-64(%rbp), %zmm1
	vmovdqu64	%zmm1, (%rsi)
	xorl	%eax, %eax
	leave
	ret
	.size	compress_expand, .-compress_expand
	.section	.note.GNU-stack,"",@progbits
