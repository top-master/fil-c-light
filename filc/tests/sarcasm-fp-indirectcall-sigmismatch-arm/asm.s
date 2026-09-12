/* Annotated register-indirect calls whose CALLSITE signature differs from the
   callee's real signature: the inline indirect-call sequence must take the GENERIC
   (buffer-CC) arm with float/double arguments and returns.

   - dbar calls dcal (real sig double(double)) through a double(int, double)
     callsite: the generic arm stores the int argument at buffer[128+8*0] (the
     declaration index of the FIRST argument) and the double argument (an 8-byte
     store) at buffer[128+8*1]; the callee's generic entrypoint loads ITS double
     argument from buffer[128+8*0] -- i.e. the int argument's bit pattern becomes
     the callee's double. Deterministic: the seed 0x3FF0000000000000 is the double
     1.0, the callee doubles it, and the FP return is read back from buffer[128]
     (ldr d0) as 2.0.

   - fbar calls fcal (real sig float(float)) through a float(double) callsite: the
     double-declared argument stores 8 bytes at buffer[128]; the callee loads the
     low 4 bytes as its float (float bits of the low half of 0.5 = 0.0f), doubles
     it, and the FP return is read back with a 4-byte load (ldr s0). */
	.text
	.p2align 4
	.global	dbar
	.type	dbar, %function
dbar:                           ;! long(ptr, long, double)
	mov	x8, x0
	mov	x0, x1
	blr	x8 ;! double(int, double)
	fcvtzs	x0, d0
	ret
	.size	dbar, .-dbar

	.p2align 4
	.global	fbar
	.type	fbar, %function
fbar:                           ;! long(ptr, double)
	mov	x8, x0
	blr	x8 ;! float(double)
	fcvtzs	x0, s0
	ret
	.size	fbar, .-fbar
	.section	.note.GNU-stack,"",@progbits
