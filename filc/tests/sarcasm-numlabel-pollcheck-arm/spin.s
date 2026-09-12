	.file	"spin.c"
	.text
	.global	spin
	.type	spin, %function
spin:                           ;! void(ptr)
	mov	x1, 0
1:
	add	x1, x1, 1
	b	1b
	ret
	.size	spin, .-spin
	.section	.note.GNU-stack,"",@progbits
