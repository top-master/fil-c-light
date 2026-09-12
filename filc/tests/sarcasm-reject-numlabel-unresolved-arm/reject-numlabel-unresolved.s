// `b 7f` has no `7:` definition anywhere after it, so sarcasm must reject this
// cleanly at parse time: "unresolved numeric label reference '7f'". The `1:`/`1b`
// loop is fine on its own; it just proves other numeric labels don't save the bad ref.
	.text
	.global	f
	.type	f, %function
f:                              ;! long(long)
	mov	x1, 0
1:
	add	x1, x1, 1
	cmp	x1, x0
	b.lt	1b
	b	7f
	ret
	.size	f, .-f
