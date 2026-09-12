#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

void shift_cl_ops(unsigned char* p);

static uint64_t ror64(uint64_t v, int c) { return (v >> c) | (v << (64 - c)); }

int main()
{
	unsigned char* p = calloc(9, 8);
	if (!p)
		return 1;
	*(uint64_t*)p = 3;
	*(uint32_t*)(p + 8) = 6;
	*(uint32_t*)(p + 12) = 5;
	*(uint64_t*)(p + 16) = 0x8000000000000000UL;
	*(uint64_t*)(p + 24) = 0x0123456789ABCDEFUL;
	*(uint64_t*)(p + 32) = 0xF000000000000000UL;
	*(uint32_t*)(p + 40) = 4;
	*(uint64_t*)(p + 48) = 0x12345UL;
	shift_cl_ops(p);
	int fails = 0;
	if (*(uint64_t*)p != 3UL << 6) { printf("shlq cl: %lx\n", *(uint64_t*)p); fails = 1; }
	if (*(uint64_t*)(p + 16) != 0x8000000000000000UL >> 8) { printf("shrq cl: %lx\n", *(uint64_t*)(p + 16)); fails = 1; }
	if (*(uint64_t*)(p + 24) != ror64(0x0123456789ABCDEFUL, 8)) { printf("rorq cl: %lx\n", *(uint64_t*)(p + 24)); fails = 1; }
	if (*(uint64_t*)(p + 32) != (uint64_t)(-(1LL << 60) >> 8)) { printf("sarq cl: %lx\n", *(uint64_t*)(p + 32)); fails = 1; }
	if (*(uint64_t*)(p + 48) != 0x12345UL << 4) { printf("shlq cl2: %lx\n", *(uint64_t*)(p + 48)); fails = 1; }
	if (*(uint64_t*)(p + 56) != 0x1111111111111111UL || *(uint64_t*)(p + 64) != 0x2222222222222222UL) {
		printf("pressure clobbered\n"); fails = 1;
	}
	free(p);
	if (fails)
		return 1;
	printf("shift-cl att ok\n");
	return 0;
}
