	.text
	.p2align 4
	.global	foo
	.type	foo, %function
foo:                            ;! long(ptr, long)
	# foo receives a pointer to a function pointer: load the callee with an
	# annotated pointer load (the migration for memory-operand calls), then
	# call the loaded function-pointer value.
	ldr	x8, [x0] ;! load ptr
	add	x0, x1, #1
	blr	x8 ;! ptr(long)
	ldr	x0, [x0]
	add	x0, x0, #67
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
