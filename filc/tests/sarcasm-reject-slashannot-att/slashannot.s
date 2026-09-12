# `//!` is NOT an annotation marker on x86_64 (only `;!` and `#!` are): the
# text stays in the code part and produces a parse error.
	.text
	.globl	f
	.type	f, @function
f:	//! unsigned(ptr)
	movq	(%rdi), %rax
	ret
	.size	f, .-f
