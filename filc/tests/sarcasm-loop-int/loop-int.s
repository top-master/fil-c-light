# Intel-syntax twin of sarcasm-loop-att: the `loop` family as a modeled
# conditional branch on the decremented rcx. Hardware ground truth (plain
# as + gcc): loop_count(0)=3, loop_rcx(0)=0.
	.intel_syntax noprefix
	.text
	.globl	loop_count
	.type	loop_count, @function
loop_count:                     ;! long(ptr)
	endbr64
	mov	rcx, 3
	xor	eax, eax
.Lcount:
	inc	eax
	mov	rsi, QWORD PTR [rdi]
	loop	.Lcount
	ret
	.size	loop_count, .-loop_count
	.globl	loop_rcx
	.type	loop_rcx, @function
loop_rcx:                       ;! long(ptr)
	endbr64
	mov	rcx, 3
.Lspin:
	loop	.Lspin
	mov	rax, rcx
	ret
	.size	loop_rcx, .-loop_rcx
	.section	.note.GNU-stack,"",@progbits
