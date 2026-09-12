# FSGSBASE (wrfsbase/wrgsbase and the rd forms) reads or writes the fs/gs
# thread-pointer BASE registers, which the Fil-C runtime owns: wrfsbase with a
# canonical value silently replaces fs.base (no fault, TLS just breaks for the
# whole thread) and the rd forms leak the thread pointer. Must be a clean
# compile-time rejection, not a raw passthrough.
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	endbr64
	movq	%rdi, %rax
	wrfsbase	%rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
