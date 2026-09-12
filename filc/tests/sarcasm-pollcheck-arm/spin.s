	.file	"spin.c"
	.text
	.global	spin
	.type	spin, %function
spin:                           ;! void(ptr)
	mov	x1, 0
.Lspin_loop:
	add	x1, x1, 1
	b	.Lspin_loop
	ret
	.size	spin, .-spin
	.section	.note.GNU-stack,"",@progbits
