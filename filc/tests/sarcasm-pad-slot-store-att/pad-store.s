# A store to (%rsp) while a `pushq %rbx` sits in the transient prologue pad
# (pushed BEFORE the first frame touch) targets the pushed register's save
# slot. The slot's content is mirrored by rbx's web (the matching pop is
# dropped), so the store must define rbx's web and the pop must yield the
# stored value -- exactly like real x86. This used to miscompile silently:
# the store virtualized into an unrelated slot web and the dropped pop
# resurrected the stale pre-push value (real x86 returned 0x4141414141414141;
# sarcasm returned 111).
	.text
	.globl	pad_slot_store
	.type	pad_slot_store, @function
pad_slot_store:                 ;! long(ptr)
	endbr64
	movq	%rdi, %rax
	subq	$64, %rsp
	movl	$111, %ebx
	pushq	%rbx
	movabsq	$0x4141414141414141, %rcx
	movq	%rcx, (%rsp)
	popq	%rbx
	movq	%rbx, %rax
	addq	$64, %rsp
	ret
	.size	pad_slot_store, .-pad_slot_store

	.globl	pad_slot_store_twice
	.type	pad_slot_store_twice, @function
pad_slot_store_twice:           ;! long(ptr)
	endbr64
	movq	%rdi, %rax
	subq	$64, %rsp
	movl	$111, %ebx
	pushq	%rbx
	movabsq	$0x1111111111111111, %rcx
	movq	%rcx, (%rsp)
	movabsq	$0x2222222222222222, %rcx
	movq	%rcx, (%rsp)
	popq	%rbx
	movq	%rbx, %rax
	addq	$64, %rsp
	ret
	.size	pad_slot_store_twice, .-pad_slot_store_twice
	.section	.note.GNU-stack,"",@progbits
