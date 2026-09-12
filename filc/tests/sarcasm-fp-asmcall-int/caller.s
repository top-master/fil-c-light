# FP callsites (asm -> asm and asm -> C), Intel syntax input; sarcasm output is
# always AT&T. See the -att twin for the full description:
#
#  - calllocal:   in-module direct call, matching sig (strong-alias fast path).
#  - callext:     cross-TU call, matching sig (exe's weak callsite thunk FAST
#                 path -- the FP args ride through the thunk's getter).
#  - callc:       asm -> C direct call (filcc-compiled cfd), matching sig.
#  - callmismatch: callsite sig double(double,double) vs callee double(double)
#                 -- GENERIC buffer arm, FP args stored from their xmm
#                 registers, FP return read back from [myth+128].
#  - fplive:      an xmm8 product and the second FP argument live across a
#                 loop (pollcheck slow path clobbers vector state) and then
#                 consumed by a call. fplive(5,6): xmm8=30, xmm0=36,
#                 cfd(36,6) = 217.
	.text
	.intel_syntax noprefix
	.p2align 4
	.globl	flocal
	.type	flocal, @function
flocal:                         ;! double(double, double)
	mulsd	xmm0, xmm1
	ret
	.size	flocal, .-flocal

	.p2align 4
	.globl	calllocal
	.type	calllocal, @function
calllocal:                      ;! double(double, double)
	mov	rax, 6
	cvtsi2sdq	xmm0, rax
	mov	rax, 7
	cvtsi2sdq	xmm1, rax
	call	flocal ;! double(double, double)
	ret
	.size	calllocal, .-calllocal

	.p2align 4
	.globl	callext
	.type	callext, @function
callext:                        ;! double(double, double)
	mov	rcx, 0x3ff8000000000000         # 1.5
	mov	QWORD PTR -8[rsp], rcx
	movsd	xmm0, QWORD PTR -8[rsp]
	mov	rcx, 0x4000000000000000         # 2.0
	mov	QWORD PTR -8[rsp], rcx
	movsd	xmm1, QWORD PTR -8[rsp]
	call	dext ;! double(double, double)
	ret
	.size	callext, .-callext

	.p2align 4
	.globl	callc
	.type	callc, @function
callc:                          ;! double(double, double)
	mov	rcx, 5
	cvtsi2sdq	xmm0, rcx
	mov	rcx, 8
	cvtsi2sdq	xmm1, rcx
	call	cfd ;! double(double, double)
	ret
	.size	callc, .-callc

	.p2align 4
	.globl	callmismatch
	.type	callmismatch, @function
callmismatch:                   ;! double(double, double)
	mov	rcx, 0x4004000000000000         # 2.5
	mov	QWORD PTR -8[rsp], rcx
	movsd	xmm0, QWORD PTR -8[rsp]
	mov	rcx, 0x401d000000000000         # 7.25
	mov	QWORD PTR -8[rsp], rcx
	movsd	xmm1, QWORD PTR -8[rsp]
	call	dmul3 ;! double(double, double)
	ret
	.size	callmismatch, .-callmismatch

	.p2align 4
	.globl	fplive
	.type	fplive, @function
fplive:                         ;! double(double, double)
	movapd	xmm8, xmm0
	mulsd	xmm8, xmm1
	mov	rax, 0
.Lagain:
	add	rax, 1
	cmp	rax, 8
	jl	.Lagain
	addsd	xmm8, xmm1
	movapd	xmm0, xmm8
	call	cfd ;! double(double, double)
	ret
	.size	fplive, .-fplive
	.section	.note.GNU-stack,"",@progbits
