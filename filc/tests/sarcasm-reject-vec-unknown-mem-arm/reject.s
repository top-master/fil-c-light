/* A memory operand may only appear on a load/store that sarcasm models. tbl is
   a NEON table-lookup whose sources are all registers — a memory operand on it
   cannot be made memory-safe, so it must be rejected (the arm64 mirror of
   x86_64's v4fmaddps reject-vec-unknown-mem). */
	.arch armv8-a
	.text
	.globl	f
	.type	f, %function
f:                              ;! long(ptr)
	tbl	v0.16b, {v1.16b}, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
