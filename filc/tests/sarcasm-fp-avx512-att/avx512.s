	.text
	.globl	avx512_test
	.type	avx512_test, @function
avx512_test:                    ;! long(ptr, ptr)
	vmovdqu64	(%rdi), %zmm0
	vaddps	%zmm0, %zmm0, %zmm1
	vaddps	64(%rdi){1to16}, %zmm1, %zmm2
	vmovdqu64	%zmm2, (%rsi)
	movl	$65280, %eax
	kmovw	%eax, %k2
	movl	$61680, %ecx
	kmovw	%ecx, %k3
	kandw	%k3, %k2, %k4
	kmovw	%k4, %edx
	movzwl	%dx, %edx
	vmovdqu8	%zmm2, %zmm3{%k4}{z}
	vmovdqu64	%zmm3, 64(%rsi)
	movq	%rdx, %rax
	ret
	.size	avx512_test, .-avx512_test
	.section	.note.GNU-stack,"",@progbits
