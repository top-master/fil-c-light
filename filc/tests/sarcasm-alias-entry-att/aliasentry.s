# Alias entry labels (the asm_AES_encrypt/AES_encrypt shape): two adjacent
# .globl labels at one body — the alias immediately precedes the
# signature-annotated entry. C calls BOTH names, and a cross-function jump to
# the alias resolves to the same function (B1).
	.text
	.globl	alias_caller
	.type	alias_caller, @function
alias_caller:                   ;! long(long)
	testl	%edi, %edi
	jne	asm_triple
	movq	%rdi, %rax
	addq	$1, %rax
	ret
	.size	alias_caller, .-alias_caller
	.globl	asm_triple
	.hidden	asm_triple
asm_triple:
triple:                         ;! long(long)
	leaq	(%rdi,%rdi,2), %rax
	ret
	.size	triple, .-triple
	.section	.note.GNU-stack,"",@progbits
