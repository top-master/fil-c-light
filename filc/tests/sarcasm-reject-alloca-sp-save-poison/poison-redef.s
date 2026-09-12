# A saved-rsp carrier that is REDEFINED before the recovery is poisoned: the
# recovery can no longer prove its value is the saved stack pointer.
	.text
	.globl	poison_redef
	.type	poison_redef, @function
poison_redef:                   ;! long()
	movq	%rsp, %rax          # the save
	subq	$64+32, %rsp
	andq	$-64, %rsp          ;! alloca result size=96
	movq	%rax, 88(%rsp)      # save-store
	movq	88(%rsp), %rcx      # carrier-load
	addq	$1, %rcx            # REDEFINE the carrier
	leaq	(%rcx), %rsp        # recovery from a poisoned carrier: reject
	ret
	.size	poison_redef, .-poison_redef
	.section	.note.GNU-stack,"",@progbits
