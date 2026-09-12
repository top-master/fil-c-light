# Loading the pushed register's save slot inside the transient prologue pad:
# before any store the slot reads the PUSHED value (the register's web at the
# push); after a store it reads the stored value. Both used to miscompile
# silently (the load virtualized into an unrelated slot web whose content was
# garbage). A narrow (4-byte) load reads the low 4 bytes of the slot, i.e. the
# low 4 bytes of the register's web.
	.text
	.globl	pad_slot_load
	.type	pad_slot_load, @function
pad_slot_load:                  ;! long(ptr)
	endbr64
	movq	%rdi, %rax
	subq	$64, %rsp
	movl	$111, %ebx
	pushq	%rbx
	# Before any store: the slot reads the pushed value (111).
	movq	(%rsp), %rax
	movabsq	$0x4141414141414141, %rcx
	movq	%rcx, (%rsp)
	# After the store: the full 8 bytes, then only the low 4.
	movq	(%rsp), %rdx
	movl	(%rsp), %esi
	popq	%rbx
	addq	%rbx, %rax
	addq	%rdx, %rax
	addq	%rsi, %rax
	addq	$64, %rsp
	ret
	.size	pad_slot_load, .-pad_slot_load
	.section	.note.GNU-stack,"",@progbits
