	.arch armv8-a
	.text
	.globl	zx
	.type	zx, %function
zx:                             ;! unsigned long(ptr)
	ldr	x0, [x0]
	lsl	x0, x0, 40
	mov	w0, w0
	ret
	.size	zx, .-zx
