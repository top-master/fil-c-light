	.intel_syntax noprefix
	.text
	.globl	cpuid_vendor_int
	.type	cpuid_vendor_int, @function
cpuid_vendor_int:               ;! long(ptr)
	# cpuid leaf 0 (Intel syntax): returns the max basic leaf (eax) and stores
	# the 12-byte vendor string (ebx, edx, ecx order) into the 16-byte object
	# at rdi. The implicit eax/ecx uses and eax/ebx/ecx/edx defs are pinned
	# around the instruction exactly like in the AT&T form.
	xor	eax, eax
	xor	ecx, ecx
	cpuid
	mov	DWORD PTR [rdi], ebx
	mov	DWORD PTR [rdi+4], edx
	mov	DWORD PTR [rdi+8], ecx
	mov	DWORD PTR [rdi+12], 0
	ret
	.size	cpuid_vendor_int, .-cpuid_vendor_int

	.globl	rdtsc_now_int
	.type	rdtsc_now_int, @function
rdtsc_now_int:                  ;! long()
	rdtsc
	shl	rdx, 32
	or	rax, rdx
	ret
	.size	rdtsc_now_int, .-rdtsc_now_int

	.globl	rdtscp_now_int
	.type	rdtscp_now_int, @function
rdtscp_now_int:                 ;! long(ptr)
	rdtscp
	mov	DWORD PTR [rdi], ecx
	shl	rdx, 32
	or	rax, rdx
	ret
	.size	rdtscp_now_int, .-rdtscp_now_int

	.globl	xgetbv0_int
	.type	xgetbv0_int, @function
xgetbv0_int:                    ;! long()
	xor	ecx, ecx
	xgetbv
	ret
	.size	xgetbv0_int, .-xgetbv0_int
	.section	.note.GNU-stack,"",@progbits
