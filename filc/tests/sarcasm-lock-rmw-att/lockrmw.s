	.text
	.globl	lockrmw
	.type	lockrmw, @function
lockrmw:                        ;! long(ptr, long)
	# rdi -> long cell, rsi = v. Exercises the lock prefix on every modeled
	# mem-RMW family; the C driver mirrors the exact same operations.
	lock xaddq	%rsi, (%rdi)        # rsi = old cell; cell += v
	lock addq	%rsi, (%rdi)        # cell += old
	lock orq	$0x48, (%rdi)
	lock andq	$0x1ff, (%rdi)
	lock subq	$13, (%rdi)
	# adc/sbb: the carry-in they actually see is whatever sarcasm's injected
	# access-check sequence leaves in EFLAGS (any stc/clc choreography here
	# would NOT survive the checked path), so their stored value is not
	# asserted — the guaranteed-equal cmpxchg below overwrites the cell with
	# the original value anyway. Only execution-without-trapping of the
	# locked forms is tested.
	lock adcq	$3, (%rdi)          # carry-in clobbered by the access check
	lock sbbq	$1, (%rdi)          # carry-in clobbered by the access check
	lock negq	(%rdi)
	lock notq	(%rdi)
	lock incq	(%rdi)
	lock decq	(%rdi)
	lock xorb	$0x5a, (%rdi)
	# guaranteed-equal cmpxchg: rax = cell, then cell = old (rsi)
	movq	(%rdi), %rax
	lock cmpxchgq	%rsi, (%rdi)
	# 16-bit lock form on the second argument cell (offset 8): andw
	lock andw	$0x0ff0, 8(%rdi)
	# return cell + old
	movq	(%rdi), %rax
	addq	%rsi, %rax
	ret
	.size	lockrmw, .-lockrmw
	.section	.note.GNU-stack,"",@progbits
