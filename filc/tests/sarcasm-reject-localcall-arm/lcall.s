// Local subroutines are not yet supported on arm64: a `bl` to a file-local
// no-signature label (whose region contains a ret) is discovered as a local
// subroutine call and rejected with a clean "not yet supported" error.
	.text
	.global	foo
	.type	foo, %function
foo:                            ;! long(long)
	mov	x9, x2
	bl	lsub
	mov	x0, x10
	ret
	.size	foo, .-foo
	.type	lsub, %function
lsub:
	add	x10, x9, #1
	ret
	.size	lsub, .-lsub
