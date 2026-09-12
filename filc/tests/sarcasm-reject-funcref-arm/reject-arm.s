/* `funcref` (function flight-pointer materialization) is x86_64-only for now;
   on arm64 it is a clean "not yet supported" rejection. */
	.text
	.global	f
	.type	f, %function
f:                              //! void()
	adrp	x8, g //! funcref
	ret
	.size	f, .-f
