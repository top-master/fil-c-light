/* `//! load ptr` alone on a line attaches to an otherwise-empty statement,
   which the shared annotation validation rejects -- like the `;!` form. */
	.arch armv8-a
	.text
	.global	f
	.type	f, %function
f:	//! void(ptr, ptr)
	//! load ptr
	ret
	.size	f, .-f
