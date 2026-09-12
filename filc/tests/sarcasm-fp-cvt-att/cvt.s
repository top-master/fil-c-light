	.text
	.globl	cvt_ss
	.type	cvt_ss, @function
cvt_ss:                         ;! long(long)
	cvtsi2ssl	%edi, %xmm0
	cvtsi2ssq	%rdi, %xmm1
	addss	%xmm1, %xmm0
	cvttss2si	%xmm0, %eax
	cvttss2siq	%xmm0, %rcx
	addq	%rcx, %rax
	addq	%rdi, %rax
	ret
	.size	cvt_ss, .-cvt_ss
	.globl	cvt_sd
	.type	cvt_sd, @function
cvt_sd:                         ;! long(long)
	cvtsi2sdl	%edi, %xmm0
	cvtsi2sdq	%rdi, %xmm1
	addsd	%xmm1, %xmm0
	cvttsd2si	%xmm0, %eax
	cvttsd2siq	%xmm0, %rcx
	addq	%rcx, %rax
	addq	%rdi, %rax
	ret
	.size	cvt_sd, .-cvt_sd
	.globl	cvt_ss_sd
	.type	cvt_ss_sd, @function
cvt_ss_sd:                      ;! long(long)
	cvtsi2sdq	%rdi, %xmm0
	cvtsd2ss	%xmm0, %xmm1
	movd	%xmm1, %eax
	cvtss2sd	%xmm1, %xmm2
	cvttsd2siq	%xmm2, %rdx
	shlq	$32, %rax
	orq	%rdx, %rax
	ret
	.size	cvt_ss_sd, .-cvt_ss_sd
	.globl	mov_dq
	.type	mov_dq, @function
mov_dq:                         ;! long(long)
	movd	%edi, %xmm0
	movq	%rdi, %xmm1
	movd	%xmm0, %eax
	movq	%xmm1, %rcx
	addq	%rcx, %rax
	addq	%rdi, %rax
	ret
	.size	mov_dq, .-mov_dq
	.globl	pins_ext
	.type	pins_ext, @function
pins_ext:                       ;! long(long)
	movd	%edi, %xmm0
	pinsrw	$2, %edi, %xmm0
	pextrw	$2, %xmm0, %eax
	ret
	.size	pins_ext, .-pins_ext
	.globl	masks
	.type	masks, @function
masks:                          ;! long(long)
	movq	%rdi, %xmm0
	movmskps	%xmm0, %eax
	pmovmskb	%xmm0, %ecx
	shlq	$16, %rcx
	orq	%rcx, %rax
	ret
	.size	masks, .-masks
	.section	.note.GNU-stack,"",@progbits
