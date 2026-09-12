/* The atomic-ptr annotation is supported on arm64's 64-bit cas — but NOT on
   the sub-word casb/cash forms: pointer slots are 8 bytes. */
	.arch_extension lse
	.text
	.global	f
	.type	f, %function
f:                              ;! int(ptr)
	casb	w0, w1, [x2]      ;! atomic ptr
	ret
	.size	f, .-f
