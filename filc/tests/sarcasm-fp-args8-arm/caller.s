/* Callers for the 8-double signature (8552919316 > 2^32), covering both
 * signature-compare sites that had to learn 16-bit-chunk movz/movk
 * materialization:
 *
 *  - call8:  cross-TU `bl f8` -- sarcasm emits the weak callsite resolver
 *            thunk (pizlonatedFI8552919316_f8) into this module, and its
 *            signature compare is the arm64_glue site.  f8 lives in
 *            libfpargs8.so with its pizlonatedFI alias localized by ver.ld,
 *            so the exe's own weak thunk is what runs (FAST path here: the
 *            signature matches, the thunk checks the FO and tail-calls the
 *            entrypoint with the eight v-register arguments untouched).
 *  - ind8:   annotated `blr` through the function pointer passed in x0, with
 *            the MATCHING 8-double callsite signature -- the inline
 *            indirect-call sequence's signature compare (the arm64_codegen
 *            cmpImmBranchWidened site) takes its fast arm.  The eight double
 *            arguments are ind8's own second through ninth arguments, so all
 *            eight v registers are live across the compare/call sequence.
 *  - ind8generic: same eight double arguments, but the callsite signature has an
 *            extra trailing int, so the signature compare fails and the generic
 *            buffer-CC arm marshals all eight doubles through the CC buffer
 *            (full 8-byte stores at 128+8i, zero aux words at 384+8i; the extra
 *            int lands past the words the callee reads) into f8's generic
 *            entrypoint; the double result comes back through [myth+128]. The
 *            mismatched callsite signature (37062648489) is itself past 2^32,
 *            so the compare that fails into the generic arm is a second user
 *            of the chunked materialization. */
	.text
	.p2align 4
	.global	call8
	.type	call8, %function
call8:                          ;! double(double)
	fmov	d1, #2.0
	fmov	d2, #3.0
	fmov	d3, #4.0
	fmov	d4, #5.0
	fmov	d5, #6.0
	fmov	d6, #7.0
	fmov	d7, #8.0
	bl	f8 ;! double(double, double, double, double, double, double, double, double)
	ret
	.size	call8, .-call8

	.p2align 4
	.global	ind8
	.type	ind8, %function
ind8:                           ;! double(ptr, double, double, double, double, double, double, double, double)
	mov	x8, x0
	blr	x8 ;! double(double, double, double, double, double, double, double, double)
	ret
	.size	ind8, .-ind8

	.p2align 4
	.global	ind8generic
	.type	ind8generic, %function
ind8generic:                    ;! double(ptr, double, double, double, double, double, double, double, double, int)
	mov	x8, x0
	blr	x8 ;! double(double, double, double, double, double, double, double, double, int)
	ret
	.size	ind8generic, .-ind8generic
	.section	.note.GNU-stack,"",@progbits
