# Callers for the 8-double signature (8552919316 > imm32), covering both
# signature-compare sites that had to learn to materialize the constant:
#
#  - call8:  cross-TU `call f8` -- sarcasm emits the weak callsite resolver
#            thunk (pizlonatedFI8552919316_f8) into this module, and its
#            signature compare is the x86_64_glue site.  f8 lives in
#            libfpargs8.so with its pizlonatedFI alias localized by ver.ld,
#            so the exe's own weak thunk is what runs (FAST path here: the
#            signature matches, the thunk checks the FO and tail-calls the
#            entrypoint with the eight xmm-register arguments untouched).
#  - ind8:   annotated `call *%rax` through the function pointer passed in
#            %rdi, with the MATCHING 8-double callsite signature -- the inline
#            indirect-call sequence's signature compare (the x86_64_codegen
#            cmpImmBranchWidened site) takes its fast arm.  The eight double
#            arguments are ind8's own second through ninth arguments, so all
#            eight xmm registers are live across the compare/call sequence.
#  - ind8generic: same eight double arguments, but the callsite signature has
#            an extra trailing int, so the signature compare fails and the
#            generic buffer-CC arm marshals all eight doubles through the CC
#            buffer (full 8-byte stores at 128+8i, zero aux words at 384+8i;
#            the extra int lands past the words the callee reads) into f8's
#            generic entrypoint; the double result comes back through
#            [myth+128]. The mismatched callsite signature (37062648489) is
#            itself past imm32, so the compare that fails into the generic arm
#            is a second user of the widened materialization.
	.text
	.p2align 4
	.globl	call8
	.type	call8, @function
call8:                          ;! double(double)
	endbr64
	movq	%rdi, %rax
	movl	$2, %eax
	cvtsi2sdl	%eax, %xmm1
	movl	$3, %eax
	cvtsi2sdl	%eax, %xmm2
	movl	$4, %eax
	cvtsi2sdl	%eax, %xmm3
	movl	$5, %eax
	cvtsi2sdl	%eax, %xmm4
	movl	$6, %eax
	cvtsi2sdl	%eax, %xmm5
	movl	$7, %eax
	cvtsi2sdl	%eax, %xmm6
	movl	$8, %eax
	cvtsi2sdl	%eax, %xmm7
	call	f8 ;! double(double, double, double, double, double, double, double, double)
	ret
	.size	call8, .-call8

	.p2align 4
	.globl	ind8
	.type	ind8, @function
ind8:                           ;! double(ptr, double, double, double, double, double, double, double, double)
	movq	%rdi, %rax
	call	*%rax ;! double(double, double, double, double, double, double, double, double)
	ret
	.size	ind8, .-ind8

	.p2align 4
	.globl	ind8generic
	.type	ind8generic, @function
ind8generic:                    ;! double(ptr, double, double, double, double, double, double, double, double, int)
	movq	%rdi, %rax
	call	*%rax ;! double(double, double, double, double, double, double, double, double, int)
	ret
	.size	ind8generic, .-ind8generic
	.section	.note.GNU-stack,"",@progbits
