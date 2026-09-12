	.intel_syntax noprefix
	.text
	.globl	id
	.type	id, @function
id:                             ;! long(long)
	mov	rax, rdi
	ret
	.size	id, .-id
	.globl	foo
	.type	foo, @function
foo:                            ;! long(ptr, long)
	push	rbp
	mov	rbp, rsp
	sub	rsp, 48
	mov	QWORD PTR [rbp - 8], rdi     # the pointer argument, spilled through an rbp-relative slot
	mov	DWORD PTR [rbp - 16], esi    # v, through another slot
	mov	rdi, 0                       # clobber the argument register: the slot now holds the only copy
	mov	edi, 7
	call	id                           ;! long(long)    # safepoint while the pointer lives only in the slot
	mov	rax, QWORD PTR [rbp - 8]     # reload the pointer from the slot
	mov	ecx, DWORD PTR [rbp - 16]    # reload v
	mov	BYTE PTR [rax], cl           # write through the reloaded pointer
	movsx	edx, BYTE PTR [rax]          # read through the reloaded pointer
	mov	QWORD PTR [rsp + 16], rax    # park the pointer in an rsp-relative slot
	mov	DWORD PTR [rsp + 24], edx    # park the byte read
	mov	rdi, QWORD PTR [rsp + 16]    # reload the pointer from the rsp-relative slot
	mov	esi, 33
	call	foo2                         ;! void(ptr)     # writes '!' at buf[0]
	mov	rax, QWORD PTR [rsp + 16]    # reload the pointer once more
	movsx	edx, BYTE PTR [rax]          # read -> 33
	mov	eax, DWORD PTR [rsp + 24]    # the parked byte -> 42
	add	eax, edx                     # 75
	add	eax, DWORD PTR [rbp - 16]    # + v -> 117
	lea	rsp, [rbp - 48]
	leave
	ret
	.size	foo, .-foo
	.globl	foo2
	.type	foo2, @function
foo2:                           ;! void(ptr)
	mov	rax, rdi
	mov	BYTE PTR [rax], 33
	ret
	.size	foo2, .-foo2
	.section	.note.GNU-stack,"",@progbits
