# An out-of-region access in a dynamic alloca scope: the region redirect rides
# the checked path, so the runtime bounds check traps with a Fil-C safety
# error. region base = rsp (the `movq %rsp` result, bias 0), size = 16; a store
# at region offset 24 is past the 16-byte allocation.
	.text
	.globl	dynoob_like
	.type	dynoob_like, @function
dynoob_like:                    #! void(long)
	movq	%rsp, %rcx          # prologue rsp save (phantom carrier)
	leaq	16(,%rdi,8), %r10   # r10 = 8*n + 16 = the region size (dynamic)
	subq	%r10, %rsp          #! alloca size (dynoob)
	movq	%rsp, %r11          #! alloca result (dynoob)
	movq	$1234, 24(%rsp)     # region[24]: OOB whenever the region is smaller
	movq	24(%rsp), %rax      # (read back through the same bad slot)
	movq	%rcx, %rsp          # rsp recovery from the carrier
	ret
	.size	dynoob_like, .-dynoob_like
	.section	.note.GNU-stack,"",@progbits
