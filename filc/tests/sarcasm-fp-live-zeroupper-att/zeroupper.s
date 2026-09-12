	.text
	.globl	zero_upper
	.type	zero_upper, @function
zero_upper:                     ;! long(ptr, long)
	# The movss LOAD writes xmm3[0:4) and architecturally ZEROES xmm3[4:16).
	# The movdqu store after the loop reads all 16 bytes, so liveness records
	# 16 bytes live at the loop pollchecks and the save/restore must preserve
	# the ZEROED upper 12 bytes too (movdqu at slot 3, not movss — verified
	# via -S). If only the low 4 bytes were preserved, a clobbering pollcheck
	# slow path would leave garbage in the upper bytes of the store.
	movss	(%rdi), %xmm3
	testq	%rsi, %rsi
	je	.Ldone
.Lloop:
	subq	$1, %rsi
	jne	.Lloop
.Ldone:
	movdqu	%xmm3, 16(%rdi)
	movl	$0, %eax
	ret
	.size	zero_upper, .-zero_upper
	.section	.note.GNU-stack,"",@progbits
