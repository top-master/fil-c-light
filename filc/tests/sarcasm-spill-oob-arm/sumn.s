	.arch armv8-a
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
	ldr	x15, [x0, 104]
	ldr	x16, [x0, 112]
	ldr	x17, [x0, 120]
	ldr	x19, [x0, 128]
	ldr	x20, [x0, 136]
	ldr	x21, [x0, 144]
	ldr	x22, [x0, 152]
	ldr	x23, [x0, 160]
	ldr	x24, [x0, 168]
	ldr	x25, [x0, 176]
	ldr	x26, [x0, 184]
	ldr	x27, [x0, 192]
	ldr	x28, [x0, 200]
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
	add	x1, x1, x15
	add	x1, x1, x16
	add	x1, x1, x17
	add	x1, x1, x19
	add	x1, x1, x20
	add	x1, x1, x21
	add	x1, x1, x22
	add	x1, x1, x23
	add	x1, x1, x24
	add	x1, x1, x25
	add	x1, x1, x26
	add	x1, x1, x27
	add	x1, x1, x28
	mov	x0, x1
	ret
	.size	sumn, .-sumn
