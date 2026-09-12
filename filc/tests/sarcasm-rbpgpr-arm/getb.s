	.text
	.globl	getb
	.type	getb, %function
	# ARM64 port of the frame-pointer-as-GPR test: x29 (fp) used as a general
	# register holding a pointer. Two arm64 frame-policy quirks shape the port:
	#   * `mov x29, ...` / `add x29, ...` are unconditionally dropped as fp
	#     setup, so the pointer is moved into x29 with `orr` (not dropped).
	#   * memory operands based on x29 are treated as frame slots, so the
	#     load address is first computed into x9.
	# The leaf function needs no x29 save: sarcasm virtualizes input x29 like
	# any other register and preserves the real fp in its own prologue.
getb:                           ;! unsigned(ptr, size_t)
	orr	x29, x0, xzr
	add	x9, x29, x1
	ldrb	w0, [x9]
	ret
	.size	getb, .-getb
	.section	.note.GNU-stack,"",@progbits
