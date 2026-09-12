	.file	"spin.c"
	.text
	.globl	spin
	.type	spin, @function
spin:                           ;! void(ptr)
	movq	$0, %rax
1:
	addq	$1, %rax
	jmp	1b
	ret
	.size	spin, .-spin
	.section	.note.GNU-stack,"",@progbits
