# Reading a saved-rsp carrier for anything but a carrier flow (here:
# arithmetic) poisons it -- the parked value does not exist in the output.
	.text
	.globl	poison_read
	.type	poison_read, @function
poison_read:                    ;! long()
	movq	%rsp, %rax          # the save
	subq	$64+32, %rsp
	andq	$-64, %rsp          ;! alloca result size=96
	movq	%rax, 88(%rsp)      # save-store
	movq	88(%rsp), %rcx      # carrier-load
	movq	%rcx, %rdx          # carrier copies are fine...
	addq	%rdx, %rcx          # ...but arithmetic on one is not: reject
	leaq	(%rcx), %rsp
	ret
	.size	poison_read, .-poison_read
	.section	.note.GNU-stack,"",@progbits
