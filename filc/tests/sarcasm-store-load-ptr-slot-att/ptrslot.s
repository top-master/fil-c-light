# A pointer parked in a stack slot with `;! store ptr` and reloaded with
# `;! load ptr` must keep its capability: the store seeds the slot's tracked
# capability and the load reconstructs it. mont5's powerx5 stored the tp
# pointer to 24+8(%rsp) WITHOUT `;! store ptr` (only the later load carried
# `;! load ptr`), so the capability slot was never seeded and the reloaded
# pointer had a null capability — a "cannot read pointer with null object"
# trap in the sqrx8x copy block at num>=24. This round-trip must reload the
# pointer intact.
	.text
	.globl	store_load_ptr_slot
	.type	store_load_ptr_slot, @function
store_load_ptr_slot:            ;! long(ptr)
	pushq	%rbx
	subq	$64, %rsp             ;! alloca result size=64
	movq	%rdi, 32(%rsp)        ;! store ptr
	movq	(%rdi), %rbx          # read *out (the arg value)
	movq	32(%rsp), %rax        ;! load ptr
	movq	%rbx, (%rax)          # write through the reloaded pointer
	movq	(%rax), %rax          # read it back
	addq	$64, %rsp
	popq	%rbx
	ret
	.size	store_load_ptr_slot, .-store_load_ptr_slot
	.section	.note.GNU-stack,"",@progbits
