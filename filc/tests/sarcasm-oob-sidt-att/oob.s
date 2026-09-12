	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# sidt stores exactly 10 bytes (2-byte limit + 8-byte base). The buffer
	# is 16 bytes and the store is at offset 8: 8+8=16 would pass the old
	# 8-byte check; 8+10=18 traps at the correct 10-byte width.
	sidt	8(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
