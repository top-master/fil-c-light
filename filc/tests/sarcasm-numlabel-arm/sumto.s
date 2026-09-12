	.file	"sumto.c"
	.text
	.globl	sumto
	.type	sumto, %function
sumto:                          ;! long(long)
	mov	x1, 0
	cmp	x0, 0
	b.gt	1f
	mov	x0, x1
	ret
1:
	mov	x2, 1
2:
	add	x1, x1, x2
	add	x2, x2, 1
	cmp	x2, x0
	b.le	2b
	mov	x0, x1
	ret
	.size	sumto, .-sumto
	.section	.note.GNU-stack,"",@progbits
