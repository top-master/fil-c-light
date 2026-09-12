/* `.section .init` content (annotated constructor calls) is x86_64-only for
   now; on arm64 it is a clean "not yet supported" rejection. */
	.section	.init
	bl	setup //! void()
	.text
	.global	f
	.type	f, %function
f:                              //! void()
	ret
	.size	f, .-f
