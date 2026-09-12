	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	endbr64
	# tpause reads the implicit edx:eax TSC-deadline pair; the def/use model
	# cannot express that, so regalloc could silently miscompile: reject.
	tpause	%eax
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
