	.intel_syntax noprefix
	.text
	.globl	lockrmw
	.type	lockrmw, @function
lockrmw:                        ;! long(ptr, long)
	# rdi -> long cell, rsi = v. Exercises the lock prefix on every modeled
	# mem-RMW family; the C driver mirrors the exact same operations.
	lock xadd	QWORD PTR [rdi], rsi    # rsi = old cell; cell += v
	lock add	QWORD PTR [rdi], rsi    # cell += old
	lock or	QWORD PTR [rdi], 0x48
	lock and	QWORD PTR [rdi], 0x1ff
	lock sub	QWORD PTR [rdi], 13
	# adc/sbb: the carry-in they actually see is whatever sarcasm's injected
	# access-check sequence leaves in EFLAGS (any stc/clc choreography here
	# would NOT survive the checked path), so their stored value is not
	# asserted — the guaranteed-equal cmpxchg below overwrites the cell with
	# the original value anyway. Only execution-without-trapping of the
	# locked forms is tested.
	lock adc	QWORD PTR [rdi], 3      # carry-in clobbered by the access check
	lock sbb	QWORD PTR [rdi], 1      # carry-in clobbered by the access check
	lock neg	QWORD PTR [rdi]
	lock not	QWORD PTR [rdi]
	lock inc	QWORD PTR [rdi]
	lock dec	QWORD PTR [rdi]
	lock xor	BYTE PTR [rdi], 0x5a
	# guaranteed-equal cmpxchg: rax = cell, then cell = old (rsi)
	mov	rax, QWORD PTR [rdi]
	lock cmpxchg	QWORD PTR [rdi], rsi
	# 16-bit lock form on the second argument cell (offset 8): andw
	lock and	WORD PTR 8[rdi], 0x0ff0
	# return cell + old
	mov	rax, QWORD PTR [rdi]
	add	rax, rsi
	ret
	.size	lockrmw, .-lockrmw
	.section	.note.GNU-stack,"",@progbits
