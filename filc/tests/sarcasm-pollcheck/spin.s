	.file	"spin.c"
	.text
	.globl	spin
	.type	spin, @function
spin:                           ;! void(ptr)
	movq	$0, %rax
.Lspin_loop:
	addq	$1, %rax
	jmp	.Lspin_loop
	ret
	.size	spin, .-spin
	.section	.note.GNU-stack,"",@progbits
