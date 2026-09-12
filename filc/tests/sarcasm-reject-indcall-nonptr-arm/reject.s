	.text
	.p2align 4
	.global	foo
	.type	foo, %function
foo:                            ;! long(long)
	mov	x8, x0
	# x8's web is an integer (foo's long argument), not a function pointer
	# value, so its capability is unknowable and the call cannot be checked.
	blr	x8 ;! long()
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
