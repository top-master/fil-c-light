# The `loop` family: a label-target CONDITIONAL branch on the (implicitly)
# decremented rcx. Sarcasm used to classify loop as control="none" with no
# register effects: the rcx decrement was unmodeled (a live rcx web silently
# kept its pre-loop value) and the branch edge was invisible to the fall-off
# walk. The counter's web is now modeled (USE+DEF of rcx, precolored to the
# physical rcx the instruction actually decrements), so a countdown matches
# hardware exactly: the iteration count AND the final rcx value.
# Hardware ground truth (plain as + gcc): loop_count(0)=3, loop_rcx(0)=0,
# loop_mem(0)=6.
	.text
	.globl	loop_count
	.type	loop_count, @function
loop_count:                     ;! long(ptr)
	endbr64
	movq	$3, %rcx
	xorl	%eax, %eax
.Lcount:
	incl	%eax
	movq	(%rdi), %rsi
	loop	.Lcount
	ret
	.size	loop_count, .-loop_count
	.globl	loop_rcx
	.type	loop_rcx, @function
loop_rcx:                       ;! long(ptr)
	endbr64
	movq	$3, %rcx
.Lspin:
	loop	.Lspin
	movq	%rcx, %rax
	ret
	.size	loop_rcx, .-loop_rcx
	.globl	loop_zero
	.type	loop_zero, @function
loop_zero:                      ;! long(ptr)
	endbr64
	movq	$2, %rcx
	xorl	%eax, %eax
.Lzero:
	incl	%eax
	loop	.Lzero
	addq	%rcx, %rax
	ret
	.size	loop_zero, .-loop_zero
	.section	.note.GNU-stack,"",@progbits
