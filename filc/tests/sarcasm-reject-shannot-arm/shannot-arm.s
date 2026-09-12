/* `#!` is NOT an annotation marker on arm64 (only `;!` and `//!` are): a
   would-be annotation spelled `#!` on a label line gets the targeted
   "'#!' is not an annotation marker on arm64" error instead of being silently
   dropped (silently losing an annotation would make annotated code assemble
   as if the annotation was never written). */
	.arch armv8-a
	.text
	.global	f
	.type	f, %function
f:	#! unsigned(ptr)
	ret
	.size	f, .-f
