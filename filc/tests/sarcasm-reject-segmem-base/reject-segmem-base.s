# A SEGMENT register as a memory operand base: fs/gs-relative addressing has no
# capability to bounds-check against (the fs/gs BASES belong to the Fil-C
# runtime — see the wrfsbase rejection — and gas itself rejects the spelling:
# `(%fs)' is not a valid base/index expression). This used to crash the
# renderer with "attempt to index nil with 'fixedNum'" instead of rejecting.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	endbr64
	movq	(%fs), %rax
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
