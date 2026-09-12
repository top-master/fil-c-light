	.text
	.globl	zmm_live
	.type	zmm_live, @function
zmm_live:                       ;! long(ptr, long)
	# zmm1 and zmm2 are live at the full 64 bytes across the loop
	# pollchecks (read by the vaddps/vmovdqu64 after the loop); zmm0 and
	# zmm3 are written but DEAD there. The width-aware expansion must emit
	# exactly two vmovdqu64 stores + two vmovdqu64 loads at the pollcheck
	# (slots 1 and 2) and nothing for zmm0/zmm3 (-S verified).
	vmovdqu64	(%rdi), %zmm0
	vaddps	%zmm0, %zmm0, %zmm1
	vmovdqu64	64(%rdi), %zmm0
	vaddps	%zmm0, %zmm0, %zmm2
	vaddps	%zmm2, %zmm2, %zmm3
	testq	%rsi, %rsi
	je	.Ldone
.Lloop:
	subq	$1, %rsi
	jne	.Lloop
.Ldone:
	vaddps	%zmm2, %zmm1, %zmm1
	vmovdqu64	%zmm1, (%rdi)
	movl	$0, %eax
	ret
	.size	zmm_live, .-zmm_live
	.section	.note.GNU-stack,"",@progbits
