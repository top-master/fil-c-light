# FP callsites (asm -> asm and asm -> C):
#
#  - calllocal:   in-module direct call, matching sig (strong-alias fast path).
#  - callext:     cross-TU call, matching sig, callee in libfpasm.so whose
#                 pizlonatedFI alias is localized by ver.ld -- so the exe's own
#                 weak callsite thunk (pizlonatedFI4792_dext) is what runs, on
#                 its FAST path: the FP args must ride through the thunk's
#                 getter (leaq/movq/retq -- xmm-safe) untouched.
#  - callc:       asm -> C direct call (filcc-compiled cfd), matching sig.
#  - callmismatch: cross-TU call whose CALLSITE sig (double(double,double))
#                 deliberately differs from the callee's real sig
#                 (double(double)) -- forces the weak thunk's GENERIC buffer
#                 arm with FP args stored from their xmm registers at their
#                 declaration indices and the FP return read back from
#                 [myth+128]. The extra second arg is deterministically
#                 ignored by the callee.
#  - fplive:      an xmm8 product and the second FP argument are live across a
#                 loop (which plants a pollcheck whose slow path is an injected
#                 runtime call that clobbers caller-saved vector registers) and
#                 are then consumed by a call -- the transform's FP save/restore
#                 machinery must keep them alive. fplive(5,6): xmm8=30, xmm0=36,
#                 cfd(36,6) = 217.
	.text
	.p2align 4
	.globl	flocal
	.type	flocal, @function
flocal:                         ;! double(double, double)
	endbr64
	movq	%rdi, %rax
	mulsd	%xmm1, %xmm0
	ret
	.size	flocal, .-flocal

	.p2align 4
	.globl	calllocal
	.type	calllocal, @function
calllocal:                      ;! double(double, double)
	movq	$6, %rax
	cvtsi2sdq	%rax, %xmm0
	movq	$7, %rax
	cvtsi2sdq	%rax, %xmm1
	call	flocal ;! double(double, double)
	ret
	.size	calllocal, .-calllocal

	.p2align 4
	.globl	callext
	.type	callext, @function
callext:                        ;! double(double, double)
	movq	%rdi, %rax
	movq	$0x3ff8000000000000, %rcx       # 1.5
	movq	%rcx, -8(%rsp)
	movsd	-8(%rsp), %xmm0
	movq	$0x4000000000000000, %rcx       # 2.0
	movq	%rcx, -8(%rsp)
	movsd	-8(%rsp), %xmm1
	call	dext ;! double(double, double)
	ret
	.size	callext, .-callext

	.p2align 4
	.globl	callc
	.type	callc, @function
callc:                          ;! double(double, double)
	movq	%rdi, %rax
	movq	$5, %rcx
	cvtsi2sdq	%rcx, %xmm0
	movq	$8, %rcx
	cvtsi2sdq	%rcx, %xmm1
	call	cfd ;! double(double, double)
	ret
	.size	callc, .-callc

	.p2align 4
	.globl	callmismatch
	.type	callmismatch, @function
callmismatch:                   ;! double(double, double)
	movq	%rdi, %rax
	movq	$0x4004000000000000, %rcx       # 2.5
	movq	%rcx, -8(%rsp)
	movsd	-8(%rsp), %xmm0
	movq	$0x401d000000000000, %rcx       # 7.25
	movq	%rcx, -8(%rsp)
	movsd	-8(%rsp), %xmm1
	call	dmul3 ;! double(double, double)
	ret
	.size	callmismatch, .-callmismatch

	.p2align 4
	.globl	fplive
	.type	fplive, @function
fplive:                         ;! double(double, double)
	movapd	%xmm0, %xmm8
	mulsd	%xmm1, %xmm8
	movq	$0, %rax
.Lagain:
	addq	$1, %rax
	cmpq	$8, %rax
	jl	.Lagain
	addsd	%xmm1, %xmm8
	movapd	%xmm8, %xmm0
	call	cfd ;! double(double, double)
	ret
	.size	fplive, .-fplive
	.section	.note.GNU-stack,"",@progbits
