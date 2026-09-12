# FP liveness in a body with NO SSE instructions (x86_64): the entry
# signature's float/double args and the FP values they feed ride in the xmm
# registers even when every named operand is a GPR, so injected calls (the
# pollcheck slow path, filc_allocate, ...) must not clobber them. The
# vector-save reservation is forced from the SIGNATURE alone
# (x86_64_frame.analyzeFrame / transform.luau), and the FP save/restore liveness
# keeps xmm0 -- the ORIGINAL double argument -- alive across the pollchecks
# the loop plants.
#
#  - fnosse:  loops n times (GPR registers only; the loop header plants a
#             pollcheck whose slow path is an injected filc_pollcheck_slow
#             call that clobbers caller-saved vector state), then hands the
#             still-intact original xmm0 to fecho and returns its result.
#             Without the forced reservation the placeholders never appear,
#             and under GC stress the pollcheck slow path corrupts xmm0.
#  - fnloop:  loops n times calling a GPR-only C helper (GPR registers only),
#             then returns n -- the no-FP counterpart in the same SSE-free
#             style.
#  - fecho:   identity on its double argument (the FP consumer whose argument
#             use is what pins xmm0's liveness across the loop).
	.text
	.p2align 4
	.globl	fnosse
	.type	fnosse, @function
fnosse:                         ;! double(double, long)
	endbr64
	movq	%rdi, %rax
	xorq	%rcx, %rcx
.Lagain:
	addq	$1, %rcx
	cmpq	%rdi, %rcx
	jl	.Lagain
	call	fecho ;! double(double)
	ret
	.size	fnosse, .-fnosse

	.p2align 4
	.globl	fnloop
	.type	fnloop, @function
fnloop:                         ;! long(long)
	movq	$0, %rcx
.Lround:
	call	grecord ;! void(long)
	addq	$1, %rcx
	cmpq	%rdi, %rcx
	jl	.Lround
	movq	%rcx, %rax
	ret
	.size	fnloop, .-fnloop

	.p2align 4
	.globl	fecho
	.type	fecho, @function
fecho:                          ;! double(double)
	ret
	.size	fecho, .-fecho
	.section	.note.GNU-stack,"",@progbits
