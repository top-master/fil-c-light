	.text
	.global	sum2
	.type	sum2, %function
sum2:                           ;! unsigned long(ptr, ptr)
	mov	x2, 0
.L1:
	ldr	x3, [x0]        ;! load ptr
	cbz	x3, .L2
	ldr	x4, [x1]        ;! load ptr
	ldrb	w3, [x3]
	ldrb	w4, [x4]
	add	x2, x2, x3
	add	x2, x2, x4
	add	x0, x0, 8
	add	x1, x1, 8
	b	.L1
.L2:
	mov	x0, x2
	ret
	.size	sum2, .-sum2
	.section	.note.GNU-stack,"",@progbits
