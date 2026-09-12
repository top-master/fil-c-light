# GAP-(b)(i) probe (AT&T): a `loop` countdown whose body contains an ANNOTATED
# call with two GPR arguments. The fast-CC marshal writes the second argument
# word into dense rcx (arg words: rdx, rcx, r8, r9) and the callee clobbers rcx
# per the ABI — pre-fix the counter (pinned to physical rcx) was destroyed by
# the first call and the countdown never terminated. Post-fix the counter web is
# saved to a scratch web (which the allocator keeps out of every caller-saved
# register) before the marshal and restored after the call's result unpacking.
# Hardware ground truth (plain as + gcc): loopcall_count() = 15 (three
# iterations of acc = acc + 5 with acc = 0, 5, 10).
	.text
	.globl	loopcall_count
	.type	loopcall_count, @function
loopcall_count:                 ;! long(ptr)
	endbr64
	movq	$3, %rcx
	xorl	%eax, %eax
.Lcall:
	movq	%rax, %rdi          # call arg1 = accumulator
	movq	$5, %rsi            # call arg2 = 5 (the marshal lands it in dense rcx)
	call	loopcall_id         ;! long(long,long)
	loop	.Lcall
	ret
	.size	loopcall_count, .-loopcall_count
	.globl	loopcall_id
	.type	loopcall_id, @function
loopcall_id:                    ;! long(long,long)
	endbr64
	movq	%rdi, %rax
	addq	%rsi, %rax
	ret
	.size	loopcall_id, .-loopcall_id
	.section	.note.GNU-stack,"",@progbits
