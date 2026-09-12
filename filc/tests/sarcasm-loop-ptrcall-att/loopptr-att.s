# GAP probe (AT&T): a `loop` countdown behind a POINTER-returning annotated call.
# Under the FIP CC a ptr-returning callee delivers its result lower in retLo =
# rcx, so hardware rcx after the call IS the returned lower: the counter web
# (pinned to physical rcx) is DEFINED from the result's lower web after the
# call's result unpacking — the pre-fix code instead saved the entry counter and
# restored it after the call, stomping the returned lower, so the countdown ran
# on stale garbage and never terminated (the probe hung; a jrcxz twin took the
# wrong branch).
#
# The callee's lower is what sarcasm's model delivers at the return: a `;! ptr`
# signature's result lower is the CALLEE's modeled capability lower (a raw
# `movq %rdi, %rcx` write is not a modeled capability — lowers must be real
# object bases or zero, or the caller would root garbage into a GC root slot,
# where the GC marks filc_object_for_lower(lower) blindly). So the callee here
# zeroes rcx explicitly (`xorl %ecx, %ecx`), which is exactly the value both
# plain hardware and the sarcasm model deliver; plain-as + gcc ground truth and
# the sarcasm run then agree exactly.
# Hardware ground truth (plain as + gcc): loopret(5) = 0 (the returned lower is
# zero, so the jrcxz takes the branch and the countdown body never runs).
	.text
	.globl	loopret
	.type	loopret, @function
loopret:                        ;! long(long)
	endbr64
	call	idf                ;! ptr(long)
	xorl	%eax, %eax
	jrcxz	.Ldone
.Ltop:
	incl	%eax
	loop	.Ltop
.Ldone:
	ret
	.size	loopret, .-loopret
	.globl	idf
	.type	idf, @function
idf:                            ;! ptr(long)
	endbr64
	movq	%rdi, %rax
	xorl	%ecx, %ecx
	ret
	.size	idf, .-idf
	.section	.note.GNU-stack,"",@progbits
