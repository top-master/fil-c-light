/* FP callsites (asm -> asm and asm -> C):
 *
 *  - calllocal:   in-module direct call, matching sig (strong-alias fast path).
 *  - callext:     cross-TU call, matching sig, callee in libfpasm.so whose
 *                 pizlonatedFI alias is localized by ver.ld -- so the exe's own
 *                 weak callsite thunk (pizlonatedFI4792_dext) is what runs, on
 *                 its FAST path: the FP args must ride through the thunk's
 *                 getter (adrp/add/mov/ret -- v-register-safe) untouched.
 *  - callc:       asm -> C direct call (filcc-compiled cfd), matching sig.
 *  - callmismatch: cross-TU call whose CALLSITE sig (double(double,double))
 *                 deliberately differs from the callee's real sig
 *                 (double(double)) -- forces the weak thunk's GENERIC buffer
 *                 arm with FP args stored at their declaration indices and the
 *                 FP return read back from [myth+128]. The extra second arg is
 *                 deterministically ignored by the callee.
 *  - fplive:      a v16 product and BOTH FP arguments are live across a loop
 *                 (which plants a pollcheck whose slow path is an injected
 *                 runtime call that clobbers caller-saved vector registers) and
 *                 are then consumed by a call -- the transform's FP save/restore
 *                 machinery must keep all of them alive (the args up to the
 *                 callsite, v16 to its last use). fplive(5,6): d16=30, d0=30+6=36,
 *                 cfd(36,6) = 217.
 */
	.text
	.p2align 4
	.global	flocal
	.type	flocal, %function
flocal:                         ;! double(double, double)
	fmul	d0, d0, d1
	ret
	.size	flocal, .-flocal

	.p2align 4
	.global	calllocal
	.type	calllocal, %function
calllocal:                      ;! double(double, double)
	fmov	d0, #6.0
	fmov	d1, #7.0
	bl	flocal ;! double(double, double)
	ret
	.size	calllocal, .-calllocal

	.p2align 4
	.global	callext
	.type	callext, %function
callext:                        ;! double(double, double)
	fmov	d0, #1.5
	fmov	d1, #2.0
	bl	dext ;! double(double, double)
	ret
	.size	callext, .-callext

	.p2align 4
	.global	callc
	.type	callc, %function
callc:                          ;! double(double, double)
	fmov	d0, #5.0
	fmov	d1, #8.0
	bl	cfd ;! double(double, double)
	ret
	.size	callc, .-callc

	.p2align 4
	.global	callmismatch
	.type	callmismatch, %function
callmismatch:                   ;! double(double, double)
	fmov	d0, #2.5
	fmov	d1, #7.25
	bl	dmul3 ;! double(double, double)
	ret
	.size	callmismatch, .-callmismatch

	.p2align 4
	.global	fplive
	.type	fplive, %function
fplive:                         ;! double(double, double)
	fmul	d16, d0, d1
	mov	x9, xzr
.Lagain:
	add	x9, x9, #1
	cmp	x9, #8
	b.lt	.Lagain
	fadd	d0, d16, d1
	bl	cfd ;! double(double, double)
	ret
	.size	fplive, .-fplive
	.section	.note.GNU-stack,"",@progbits
