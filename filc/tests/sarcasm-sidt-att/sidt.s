	.text
	.globl	do_sidt
	.type	do_sidt, @function
do_sidt:                        ;! void(ptr)
	# sidt stores exactly 10 bytes (2-byte limit + 8-byte base); the old
	# width logic checked only 8. The buffer is 16 bytes, so bytes 10-15
	# must remain untouched.
	sidt	(%rdi)
	ret
	.size	do_sidt, .-do_sidt
	.section	.note.GNU-stack,"",@progbits
