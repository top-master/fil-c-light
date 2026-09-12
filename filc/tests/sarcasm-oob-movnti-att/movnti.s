	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# Regression test for the movnti memory-width fix: the width of a movnti
	# store is determined by the SOURCE REGISTER (%rsi -> 8 bytes), never by a
	# guessed default. This store must be bounds-checked as an 8-byte write:
	# offset 12 in a 16-byte object means [12,20) crosses the upper bound and
	# traps with "cannot write 8 bytes". (The old buggy 4-byte check would
	# have passed: [12,16) is in bounds. Fil-C rounds allocations up to 16
	# bytes, so the store is placed at offset 12, not 4, to cross the bound.)
	movq	$42, %rsi
	movnti	%rsi, 12(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
