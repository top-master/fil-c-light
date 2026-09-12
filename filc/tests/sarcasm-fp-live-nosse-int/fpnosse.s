# FP liveness in a body with NO SSE instructions (Intel syntax input; sarcasm
# output is always AT&T). See the -att twin for the full description.
#
#  - fnosse:  loops n times (GPR registers only), then hands the still-intact
#             original xmm0 to fecho and returns its result.
#  - fnloop:  loops n times calling a GPR-only C helper, then returns n.
#  - fecho:   identity on its double argument.
	.text
	.intel_syntax noprefix
	.p2align 4
	.globl	fnosse
	.type	fnosse, @function
fnosse:                         ;! double(double, long)
	mov	rax, rdi
	xor	rcx, rcx
.Lagain:
	add	rcx, 1
	cmp	rcx, rdi
	jl	.Lagain
	call	fecho ;! double(double)
	ret
	.size	fnosse, .-fnosse

	.p2align 4
	.globl	fnloop
	.type	fnloop, @function
fnloop:                         ;! long(long)
	mov	rcx, 0
.Lround:
	call	grecord ;! void(long)
	add	rcx, 1
	cmp	rcx, rdi
	jl	.Lround
	mov	rax, rcx
	ret
	.size	fnloop, .-fnloop

	.p2align 4
	.globl	fecho
	.type	fecho, @function
fecho:                          ;! double(double)
	ret
	.size	fecho, .-fecho
	.section	.note.GNU-stack,"",@progbits
