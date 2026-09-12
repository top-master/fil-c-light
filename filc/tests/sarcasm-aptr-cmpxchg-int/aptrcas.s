	.intel_syntax noprefix
	.text
	.globl	ap_cas
	.type	ap_cas, @function
ap_cas:                         ;! ptr(ptr, ptr)
	# rdi -> pair: [rdi] = the CAS slot, [rdi+8] = the new value (a pointer).
	# rsi = expected. Returns the old value (with its capability).
	mov	rcx, QWORD PTR [rdi+8]  ;! load ptr
	mov	rax, rsi
	cmpxchg	QWORD PTR [rdi], rcx  ;! atomic ptr
	ret
	.size	ap_cas, .-ap_cas
	.globl	ap_cas_lock
	.type	ap_cas_lock, @function
ap_cas_lock:                    ;! ptr(ptr, ptr)
	# same, with the lock prefix (still goes through the runtime call)
	mov	rcx, QWORD PTR [rdi+8]  ;! load ptr
	mov	rax, rsi
	lock cmpxchg	QWORD PTR [rdi], rcx  ;! atomic ptr
	ret
	.size	ap_cas_lock, .-ap_cas_lock
	.globl	ap_cas_zf
	.type	ap_cas_zf, @function
ap_cas_zf:                      ;! long(ptr, ptr)
	# returns ZF of the exchange (1 iff it happened): a flag consumer
	# immediately after the annotated cmpxchg must behave natively.
	mov	rcx, QWORD PTR [rdi+8]  ;! load ptr
	mov	rax, rsi
	cmpxchg	QWORD PTR [rdi], rcx  ;! atomic ptr
	sete	al
	movzx	eax, al
	ret
	.size	ap_cas_zf, .-ap_cas_zf
	.globl	ap_add
	.type	ap_add, @function
ap_add:                         ;! ptr(ptr, long)
	# the compare-exchange retry idiom: atomically add rsi to the pointer
	# slot, return the old pointer (with capability).
	mov	rax, QWORD PTR [rdi]    ;! atomic load ptr
.L1:
	mov	rcx, rax
	add	rcx, rsi
	cmpxchg	QWORD PTR [rdi], rcx  ;! atomic ptr
	jne	.L1
	ret
	.size	ap_add, .-ap_add
	.section	.note.GNU-stack,"",@progbits
