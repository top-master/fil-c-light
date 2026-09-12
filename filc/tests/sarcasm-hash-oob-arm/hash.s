	.arch armv8-a
	.file	"test.c"
	.text
	.align	2
	.p2align 4,,11
	.global	hash
	.type	hash, %function
hash:                           ;! unsigned(ptr)
.LFB0:
	.cfi_startproc
	mov	x2, x0
	mov	x0, 5381
	ldrb	w1, [x2], 1
	cbz	w1, .L1
	.p2align 3,,7
.L3:
	add	x0, x0, x0, lsl 5
	add	x0, x0, w1, uxtb
	ldrb	w1, [x2], 1
	cbnz	w1, .L3
.L1:
	ret
	.cfi_endproc
.LFE0:
	.size	hash, .-hash
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
