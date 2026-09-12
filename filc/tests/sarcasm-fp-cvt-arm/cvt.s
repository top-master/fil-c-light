/* Conversion passthrough: scvtf/ucvtf (32- and 64-bit, both directions),
   fcvtzs/fcvtzu truncation back to GPRs (including the unsigned saturation
   edge), fcvt between double/single/half, and fmov between FP and GPR
   registers. All values truncate exactly so the driver checks literal sums. */
	.arch armv8.2-a+fp16
	.text
	.globl	cvt_s64
	.type	cvt_s64, %function
cvt_s64:                        ;! long(long)
	scvtf	d0, x0
	scvtf	d1, w0
	fadd	d0, d0, d1
	fcvtzs	x2, d0
	fcvtzs	w3, d0
	add	x2, x2, x3
	add	x0, x2, x0
	ret
	.size	cvt_s64, .-cvt_s64
	.globl	cvt_u64
	.type	cvt_u64, %function
cvt_u64:                        ;! long(long)
	ucvtf	d0, x0
	fcvtzu	x1, d0
	ucvtf	d1, w0
	fcvtzu	w2, d1
	add	x0, x1, x2
	ret
	.size	cvt_u64, .-cvt_u64
	.globl	cvt_ds
	.type	cvt_ds, %function
cvt_ds:                         ;! long(long)
	fmov	d0, x0
	fcvt	s1, d0
	fcvt	d2, s1
	fcvtzs	x1, d2
	fcvtzs	w2, s1
	add	x0, x1, x2
	ret
	.size	cvt_ds, .-cvt_ds
	.globl	cvt_hf
	.type	cvt_hf, %function
cvt_hf:                         ;! long(long)
	scvtf	s0, w0
	fcvt	h1, s0
	fcvt	d2, h1
	fcvt	s3, h1
	fcvtzs	x1, d2
	fcvtzs	w2, s3
	add	x0, x1, x2
	ret
	.size	cvt_hf, .-cvt_hf
	.globl	cvt_sat
	.type	cvt_sat, %function
cvt_sat:                        ;! long(long, long)
	fmov	d0, x0
	fcvtzs	x2, d0
	fmov	s1, w1
	fcvtzs	w3, s1
	add	x0, x2, x3
	ret
	.size	cvt_sat, .-cvt_sat
	.section	.note.GNU-stack,"",@progbits
