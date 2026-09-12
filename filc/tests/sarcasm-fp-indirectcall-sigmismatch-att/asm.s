# Annotated register-indirect calls whose CALLSITE signature differs from the
# callee's real signature: the inline indirect-call sequence must take the
# GENERIC (buffer-CC) arm with float/double arguments and returns.
#
# - dbar calls dcal (real sig double(double)) through a double(int, double)
#   callsite: the generic arm stores the int argument at buffer[128+8*0] (the
#   declaration index of the FIRST argument) and the double argument (an 8-byte
#   store from %xmm0) at buffer[128+8*1]; the callee's generic entrypoint loads
#   ITS double argument from buffer[128+8*0] -- i.e. the int argument's bit
#   pattern becomes the callee's double. Deterministic: the seed
#   0x3FF0000000000000 is the double 1.0, the callee doubles it, and the FP
#   return is read back from buffer[128] (movsd) as 2.0.
#
# - fbar calls fcal (real sig float(float)) through a float(double) callsite:
#   the double-declared argument stores 8 bytes at buffer[128]; the callee
#   loads the low 4 bytes as its float (float bits of the low half of 0.5 =
#   0.0f), doubles it, and the FP return is read back with a 4-byte load
#   (movss).
	.text
	.p2align 4
	.globl	dbar
	.type	dbar, @function
dbar:                           ;! long(ptr, long, double)
	endbr64
	movq	%rdi, %rax
	movq	%rsi, %rdi
	call	*%rax ;! double(int, double)
	cvttsd2si	%xmm0, %rax
	ret
	.size	dbar, .-dbar

	.p2align 4
	.globl	fbar
	.type	fbar, @function
fbar:                           ;! long(ptr, double)
	movq	%rdi, %rax
	call	*%rax ;! float(double)
	cvttss2si	%xmm0, %rax
	ret
	.size	fbar, .-fbar
	.section	.note.GNU-stack,"",@progbits
