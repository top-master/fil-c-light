	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# lfs m16:32 is a 6-byte far-pointer load (4-byte offset + 2-byte
	# selector). The pointer is end-of-buffer minus 4: a 4-byte check would
	# pass, the correct 6-byte check traps. The trap fires at the emitted
	# bounds CHECK, so the actual lfs instruction never executes — there is
	# no FS-base clobbering risk (loading fs with a null selector would
	# zero the FS base on this machine and kill TLS).
	lfs	(%rdi), %eax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
