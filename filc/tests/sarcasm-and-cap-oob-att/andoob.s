	.text
	# Fail-closed `and`: masking the value out of bounds does not remove the
	# capability check — the access traps. `and $0` unconditionally takes the
	# result out of bounds (address 0 is below every object's lower bound).
	.globl	and_zero_trap
	.type	and_zero_trap, @function
and_zero_trap:                  ;! long(ptr)
	endbr64
	movq	%rdi, %rax
	andq	$0, %rax
	movq	(%rax), %rax
	ret
	.size	and_zero_trap, .-and_zero_trap
	.section	.note.GNU-stack,"",@progbits
