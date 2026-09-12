# Intel-syntax twin of sarcasm-loop-ptrcall-att: a `loop` countdown behind a
# pointer-returning annotated call. Under the FIP CC a ptr-returning callee
# delivers its result lower in retLo = rcx, so the counter web (pinned to
# physical rcx) is DEFINED from the result's lower web after the call's result
# unpacking; the pre-fix code restored the saved entry counter instead, stomping
# the returned lower (the countdown then ran on stale garbage and never
# terminated). The callee zeroes rcx explicitly, which is exactly the value both
# plain hardware and the sarcasm model deliver (a raw rcx write is not a modeled
# capability; lowers must be real object bases or zero).
# Hardware ground truth (plain as + gcc): loopret(5) = 0.
	.intel_syntax noprefix
	.text
	.globl	loopret
	.type	loopret, @function
loopret:                        ;! long(long)
	endbr64
	call	idf                ;! ptr(long)
	xor	eax, eax
	jrcxz	.Ldone
.Ltop:
	inc	eax
	loop	.Ltop
.Ldone:
	ret
	.size	loopret, .-loopret
	.globl	idf
	.type	idf, @function
idf:                            ;! ptr(long)
	endbr64
	mov	rax, rdi
	xor	ecx, ecx
	ret
	.size	idf, .-idf
	.section	.note.GNU-stack,"",@progbits
