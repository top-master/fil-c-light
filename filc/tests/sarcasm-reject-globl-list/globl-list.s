# A .globl with a COMMA-SEPARATED name list must register EVERY name in the
# top-level content scan: the single-name regex silently dropped the later
# names, so mydata escaped the "label outside any function" rejection and
# vanished from the object (cross-TU references then failed at link time with
# the opaque "undefined reference to pizlonated_mydata"). Data under
# .rodata/.data/.bss is collected into Fil-C data objects now, so pin the
# rejection with data in a NON-collectable section: the comma-list .globl
# still makes mydata live, and a live label outside any function rejects.
	.text
	.globl	myfunc, mydata
	.type	myfunc, @function
myfunc:                         ;! long()
	endbr64
	movl	$42, %eax
	ret
	.size	myfunc, .-myfunc
	.section	.mydata,"aw",@progbits
mydata:	.quad	12345
	.section	.note.GNU-stack,"",@progbits
