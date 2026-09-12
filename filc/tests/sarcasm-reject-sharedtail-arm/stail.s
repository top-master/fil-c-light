/* A mid-body shared-tail join (B2 cross-function jump): on arm64 the
   cross-function-jump machinery does not run, so the jump into another
   function's body keeps the clean tail-call rejection. */
	.text
	.global	foo
	.type	foo, %function
foo:                            ;! long(long)
	mov	x9, x0
	b	bar.mid
	.size	foo, .-foo
	.global	bar
	.type	bar, %function
bar:                            ;! long(long)
	add	x0, x0, #1
bar.mid:
	add	x0, x0, #2
	ret
	.size	bar, .-bar
