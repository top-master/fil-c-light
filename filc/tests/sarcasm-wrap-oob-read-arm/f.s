	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr, long)
	# Regression test for the eff+size overflow hole: with eff = -8 the naive `hi = eff + 8; hi ugt upper` upper-bound check wrapped to 0 and PASSED, so the CPU faulted on the wild address (SIGSEGV instead of a clean filc trap). The overflow-free `eff ugt upper - size` form traps cleanly ("cannot read pointer with ptr >= upper.").
	ldr	x8, [x0, x1]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
