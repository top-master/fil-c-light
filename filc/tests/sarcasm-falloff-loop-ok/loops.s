# A bounded loop whose conditional exit reaches a ret must compile AND run:
# count(n) counts down to 0 and returns it (loop back edge via jmp, conditional
# exit via je into a ret). A body ending in an INFINITE loop (jmp back to its
# own loop header, with no ret anywhere after it) has NO reachable fall-off, so
# the fall-off rejection must still accept it: spin is compiled but never
# called.
	.text
	.globl	count
	.type	count, @function
count:                          ;! long(long)
	endbr64
	movq	%rdi, %rax
.Lcount_loop:
	testq	%rax, %rax
	je	.Lcount_done
	subq	$1, %rax
	jmp	.Lcount_loop
.Lcount_done:
	ret
	.size	count, .-count
	.globl	spin
	.type	spin, @function
spin:                           ;! void()
	endbr64
	movq	$0, %rax
.Lspin_loop:
	addq	$1, %rax
	jmp	.Lspin_loop
	.size	spin, .-spin
	.section	.note.GNU-stack,"",@progbits
