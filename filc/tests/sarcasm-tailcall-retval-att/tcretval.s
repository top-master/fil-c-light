# B1 tail-branch return values: the variant's return value becomes the
# dispatcher's return value — both for an integer result and for a POINTER
# result (the capability rides the call's lower-marshalling into the
# dispatcher's own return path).
	.text
	.globl	int_dispatch
	.type	int_dispatch, @function
int_dispatch:                   ;! long(long)
	testl	%edi, %edi
	jnz	int_variant
	movq	%rdi, %rax
	negq	%rax
	ret
	.size	int_dispatch, .-int_dispatch
	.type	int_variant, @function
int_variant:                    ;! long(long)
	movq	%rdi, %rax
	addq	$1000, %rax
	ret
	.size	int_variant, .-int_variant
	.globl	ptr_dispatch
	.type	ptr_dispatch, @function
ptr_dispatch:                   ;! ptr(ptr)
	testl	%edi, %edi
	jnz	ptr_variant
	movq	%rdi, %rax
	ret
	.size	ptr_dispatch, .-ptr_dispatch
	.type	ptr_variant, @function
ptr_variant:                    ;! ptr(ptr)
	leaq	16(%rdi), %rax
	ret
	.size	ptr_variant, .-ptr_variant
	.section	.note.GNU-stack,"",@progbits
