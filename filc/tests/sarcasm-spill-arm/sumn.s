	.arch armv8-a
	.file	"spill.c"
	.text
	.global	sumn
	.type	sumn, %function
sumn:                           ;! unsigned(ptr)
	ldr	x1, [x0, 0]
	ldr	x2, [x0, 8]
	ldr	x3, [x0, 16]
	ldr	x4, [x0, 24]
	ldr	x5, [x0, 32]
	ldr	x6, [x0, 40]
	ldr	x7, [x0, 48]
	ldr	x9, [x0, 56]
	ldr	x10, [x0, 64]
	ldr	x11, [x0, 72]
	ldr	x12, [x0, 80]
	ldr	x13, [x0, 88]
	ldr	x14, [x0, 96]
	add	x1, x1, x2
	add	x1, x1, x3
	add	x1, x1, x4
	add	x1, x1, x5
	add	x1, x1, x6
	add	x1, x1, x7
	add	x1, x1, x9
	add	x1, x1, x10
	add	x1, x1, x11
	add	x1, x1, x12
	add	x1, x1, x13
	add	x1, x1, x14
	mov	x0, x1
	ret
	.size	sumn, .-sumn
	.section	.note.GNU-stack,"",@progbits
