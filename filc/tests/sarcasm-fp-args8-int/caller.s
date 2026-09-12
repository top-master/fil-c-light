# Callers for the 8-double signature (8552919316 > imm32), Intel syntax input.
# See the -att twin for the full description of the three call shapes:
# call8 (weak callsite resolver fast path), ind8 (inline indirect call, matching
# signature) and ind8generic (inline indirect call whose signature compare
# misses -> generic buffer-CC arm).
	.text
	.intel_syntax noprefix
	.p2align 4
	.globl	call8
	.type	call8, @function
call8:                          ;! double(double)
	mov	eax, 2
	cvtsi2sdl	xmm1, eax
	mov	eax, 3
	cvtsi2sdl	xmm2, eax
	mov	eax, 4
	cvtsi2sdl	xmm3, eax
	mov	eax, 5
	cvtsi2sdl	xmm4, eax
	mov	eax, 6
	cvtsi2sdl	xmm5, eax
	mov	eax, 7
	cvtsi2sdl	xmm6, eax
	mov	eax, 8
	cvtsi2sdl	xmm7, eax
	call	f8 ;! double(double, double, double, double, double, double, double, double)
	ret
	.size	call8, .-call8

	.p2align 4
	.globl	ind8
	.type	ind8, @function
ind8:                           ;! double(ptr, double, double, double, double, double, double, double, double)
	call	rdi ;! double(double, double, double, double, double, double, double, double)
	ret
	.size	ind8, .-ind8

	.p2align 4
	.globl	ind8generic
	.type	ind8generic, @function
ind8generic:                    ;! double(ptr, double, double, double, double, double, double, double, double, int)
	call	rdi ;! double(double, double, double, double, double, double, double, double, int)
	ret
	.size	ind8generic, .-ind8generic
	.section	.note.GNU-stack,"",@progbits
