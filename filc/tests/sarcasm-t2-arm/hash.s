	.arch armv8-a
	.file	"test2.c"
	.text
	.align	2
	.p2align 4,,11
	.global	hash
	.type	hash, %function
hash:                           ;! unsigned(ptr)
.LFB16:
	.cfi_startproc
	ldr	x3, [x0, 8]
	cbz	x3, .L4
	ldr	x1, [x0]        ;! load ptr
	mov	x0, 5381
	add	x3, x1, x3
	.p2align 3,,7
.L3:
	ldrb	w2, [x1], 1
	add	x0, x0, x0, lsl 5
	add	x0, x2, x0
	cmp	x1, x3
	bne	.L3
	ret
	.p2align 2,,3
.L4:
	mov	x0, 5381
	ret
	.cfi_endproc
.LFE16:
	.size	hash, .-hash
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
