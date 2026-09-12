# Intel-syntax twin of sarcasm-loop-call-att: a `loop` countdown whose body
# contains an annotated call with two GPR arguments — the fast-CC marshal
# writes argument word 2 into dense rcx and the callee clobbers rcx, so the
# counter (pinned to physical rcx) must be saved/restored around the call.
# Hardware ground truth (plain as + gcc): loopcall_count() = 15.
	.intel_syntax noprefix
	.text
	.globl	loopcall_count
	.type	loopcall_count, @function
loopcall_count:                 ;! long(ptr)
	endbr64
	mov	rcx, 3
	xor	eax, eax
.Lcall:
	mov	rdi, rax                # call arg1 = accumulator
	mov	rsi, 5                  # call arg2 = 5 (the marshal lands it in dense rcx)
	call	loopcall_id             ;! long(long,long)
	loop	.Lcall
	ret
	.size	loopcall_count, .-loopcall_count
	.globl	loopcall_id
	.type	loopcall_id, @function
loopcall_id:                    ;! long(long,long)
	endbr64
	mov	rax, rdi
	add	rax, rsi
	ret
	.size	loopcall_id, .-loopcall_id
	.section	.note.GNU-stack,"",@progbits
