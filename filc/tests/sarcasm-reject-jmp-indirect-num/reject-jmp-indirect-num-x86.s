	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# `jmp *0x600000` jumps THROUGH absolute address 0x600000: an
	# absolute 8-byte read that cannot be bounds-checked. Reject cleanly
	# (the indirect marker was previously dropped, rendering `jmp
	# $0x600000` — a cryptic assembler failure instead of this message).
	movq	%rdi, %rax
	jmp	*0x600000
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
