	.arch armv8-a
	.text
	.global	store_ptr
	.type	store_ptr, %function
store_ptr:                      ;! void(ptr, ptr)
	str	x1, [x0]        ;! store ptr
	ret
	.size	store_ptr, .-store_ptr
