# Constant-expression immediates and displacements (gas folds these at assembly
# time; OpenSSL perlasm emits them, e.g. `subq $64+32,%rsp` in sha512-x86_64.pl
# output): the prologue adjustment must be seen as a 96-byte frame — it used to
# silently fold to 0 (tonumber returned nil for "64+32" and immVal defaulted to
# 0), so the 88(%rsp) slot traffic was rejected with "frame size 0". `$1<<4`
# immediates must fold to their values, and constant-expression displacements on
# heap accesses must fold into the checked offset (a misparse as 0 would hit the
# wrong address AND the wrong bounds).
	.text
	.globl	frameexpr
	.type	frameexpr, @function
frameexpr:                      ;! long(long)
	subq	$64+32, %rsp
	movq	%rdi, 88(%rsp)
	movq	88(%rsp), %rax
	addq	$64+32, %rsp
	ret
	.size	frameexpr, .-frameexpr

	.globl	dispexpr_load
	.type	dispexpr_load, @function
dispexpr_load:                  ;! long(ptr)
	movl	512-128+8(%rdi), %eax       # 392(%rdi)
	ret
	.size	dispexpr_load, .-dispexpr_load

	.globl	dispexpr_store
	.type	dispexpr_store, @function
dispexpr_store:                 ;! void(ptr, long)
	movq	%rsi, 1024-512(%rdi)        # 512(%rdi)
	ret
	.size	dispexpr_store, .-dispexpr_store

	.globl	shiftexpr
	.type	shiftexpr, @function
shiftexpr:                      ;! long()
	movq	$1<<4, %rax                 # 16
	addq	$(2<<3)+1, %rax             # 17
	addq	$0x10+0x20, %rax            # 48: total 81
	ret
	.size	shiftexpr, .-shiftexpr
	.section	.note.GNU-stack,"",@progbits
