/* `#!` is NOT an annotation marker on arm64 (only `;!` and `//!` are): a
   would-be annotation spelled `#!` on its own line inside a function body is
   now diagnosed with a targeted error instead of being silently swallowed
   (silently losing an annotation would make annotated code assemble as if the
   annotation was never written). */
	.arch armv8-a
	.text
	.global	f
	.type	f, %function
f:                              //! unsigned(ptr)
	ldr	x0, [x0]            //! load ptr
	#! store ptr
	ret
	.size	f, .-f
