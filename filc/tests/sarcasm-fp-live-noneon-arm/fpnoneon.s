/* FP liveness in a body with NO NEON register operands (arm64): the entry
   signature's float/double args and the FP values they feed ride in v
   registers even when every named operand is an x register, so injected
   calls (the pollcheck slow path, filc_allocate, ...) must not clobber them.
   The vector-save reservation is forced from the SIGNATURE alone
   (arm64_frame.analyzeFrame / transform.luau), and the FP save/restore
   liveness keeps d0 — the ORIGINAL double argument — alive across the
   pollchecks the loop plants.

    - fnoneon:  loops n times (x regs only; the loop header plants a
                pollcheck whose slow path is an injected filc_pollcheck_slow
                call that clobbers caller-saved vector state), then hands the
                still-intact original d0 to fecho and returns its result.
                Without the forced reservation the placeholders never appear,
                and under GC stress the pollcheck slow path corrupts d0.
    - fnloop:   loops n times calling a GPR-only C helper (x regs only),
                then returns n — the no-FP counterpart in the same NEON-free
                style.
    - fecho:    identity on its double argument (the FP consumer whose
                argument use is what pins d0's liveness across the loop). */
	.text
	.p2align 4
	.global	fnoneon
	.type	fnoneon, %function
fnoneon:                        ;! double(double, long)
	mov	x9, xzr
.Lagain:
	add	x9, x9, #1
	cmp	x9, x0
	b.lt	.Lagain
	bl	fecho ;! double(double)
	ret
	.size	fnoneon, .-fnoneon

	.p2align 4
	.global	fnloop
	.type	fnloop, %function
fnloop:                         ;! long(long)
	mov	x9, xzr
.Lround:
	mov	x1, x0
	bl	grecord ;! void(long)
	add	x9, x9, #1
	cmp	x9, x0
	b.lt	.Lround
	mov	x0, x9
	ret
	.size	fnloop, .-fnloop

	.p2align 4
	.global	fecho
	.type	fecho, %function
fecho:                          ;! double(double)
	ret
	.size	fecho, .-fecho
	.section	.note.GNU-stack,"",@progbits
