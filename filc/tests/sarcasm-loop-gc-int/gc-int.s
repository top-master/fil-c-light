# Intel-syntax twin of sarcasm-loop-gc-att: an implicit-counter countdown whose
# body runs an allocation-churn loop (the churn back edge is not the counter's
# own header, so the injected pollcheck there had no rcx save pre-fix, and the
# injected filc_allocate call clobbered rcx outright). Post-fix every pollcheck
# in a counter function preserves rcx and the counter is saved/restored around
# every call. The churn is an injected `;! alloca` so the stripped body makes
# no call at all and the raw-hardware ground truth is deterministic.
# Hardware ground truth (plain as + gcc): loopgc_count() = 1000.
	.intel_syntax noprefix
	.text
	.globl	loopgc_count
	.type	loopgc_count, @function
loopgc_count:                   ;! long(ptr)
	endbr64
	mov	rcx, 1000
	xor	eax, eax
.Louter:
	mov	r10d, 0
.Lchurn:
	lea	r9, [rsp - 8]           ;! alloca result size=16
	inc	r10d
	cmp	r10d, 1000
	jb	.Lchurn
	inc	eax
	loop	.Louter
	ret
	.size	loopgc_count, .-loopgc_count
	.section	.note.GNU-stack,"",@progbits
