# Top-level (inter-function) data that sarcasm cannot turn into a data object
# must still be rejected, not silently dropped (a silently dropped global would
# make any reach of it hand out a raw address). Data under .rodata/.data/.bss
# IS collected into Fil-C data objects now; a live (global) label naming data
# in a NON-collectable section keeps the original "label outside any function"
# rejection with the same diagnostic.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! unsigned(void)
	endbr64
	movq	%rdi, %rax
	movl	$42, %eax
	ret
	.size	foo, .-foo
	.section	.mydata,"aw",@progbits
	.globl	myglob
myglob:
	.quad	42
	.section	.note.GNU-stack,"",@progbits
