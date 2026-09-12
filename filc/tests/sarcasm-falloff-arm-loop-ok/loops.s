/* A bounded loop whose conditional exit reaches a ret must compile AND run:
   count(n) counts down to 0 and returns it (loop back edge via b, conditional
   exit via b.eq into a ret). A body ending in an INFINITE loop (b back to its
   own loop header, with no ret anywhere after it) has NO reachable fall-off,
   so the fall-off rejection must still accept it: spin is compiled but never
   called. */
	.text
	.globl	count
	.type	count, %function
count:                          ;! long(long)
	mov	x1, x0
.Lcount_loop:
	cmp	x1, 0
	b.eq	.Lcount_done
	sub	x1, x1, 1
	b	.Lcount_loop
.Lcount_done:
	mov	x0, x1
	ret
	.size	count, .-count
	.globl	spin
	.type	spin, %function
spin:                           ;! void()
	mov	x0, 0
.Lspin_loop:
	add	x0, x0, 1
	b	.Lspin_loop
	.size	spin, .-spin
