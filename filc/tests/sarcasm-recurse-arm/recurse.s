	.arch armv8-a
	.text
	.global	recurse
	.type	recurse, %function
recurse:                        ;! void(ptr)
	bl	recurse ;! void(ptr)
	ret
	.size	recurse, .-recurse
