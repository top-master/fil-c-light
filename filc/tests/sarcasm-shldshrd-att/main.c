#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

void shldshrd_ops(unsigned char* p);

static uint32_t rotl32(uint32_t v, int c) { return (v << c) | (v >> (32 - c)); }
static uint32_t rotr32(uint32_t v, int c) { return (v >> c) | (v << (32 - c)); }
static uint64_t rotl64(uint64_t v, int c) { return (v << c) | (v >> (64 - c)); }

int main()
{
	unsigned char* p = calloc(10, 8);
	if (!p)
		return 1;
	*(uint32_t*)p = 0x12345678U;
	*(uint32_t*)(p + 4) = 0xA5A5A5A5U;
	*(uint32_t*)(p + 8) = 0xDEADBEEFU;
	*(uint32_t*)(p + 12) = 0x89ABCDEFU;
	*(uint64_t*)(p + 16) = 0x0123456789ABCDEFUL;
	*(uint64_t*)(p + 24) = 0xFEDCBA9876543210UL;
	*(uint32_t*)(p + 32) = 11;
	*(uint64_t*)(p + 40) = 0x1111222233334444UL;
	*(uint64_t*)(p + 48) = 0xAAAABBBBCCCCDDDDUL;
	*(uint32_t*)(p + 56) = 0x0F0F0F0FU;
	shldshrd_ops(p);
	int fails = 0;
	if (*(uint32_t*)p != 0x468acf02U) { printf("shldl self: %x\n", *(uint32_t*)p); fails = 1; }
	uint32_t want4 = (0xA5A5A5A5U << 9) | (0xDEADBEEFU >> 23);
	if (*(uint32_t*)(p + 4) != want4) { printf("shldl distinct: %x want %x\n", *(uint32_t*)(p + 4), want4); fails = 1; }
	if (*(uint32_t*)(p + 12) != rotr32(0x89ABCDEFU, 13)) { printf("shrdl self: %x\n", *(uint32_t*)(p + 12)); fails = 1; }
	uint64_t want16 = (0x0123456789ABCDEFUL >> 17) | (0xFEDCBA9876543210UL << 47);
	if (*(uint64_t*)(p + 16) != want16) { printf("shrdq distinct: %lx want %lx\n", *(uint64_t*)(p + 16), want16); fails = 1; }
	uint64_t want40 = (0x1111222233334444UL << 11) | (0xAAAABBBBCCCCDDDDUL >> 53);
	if (*(uint64_t*)(p + 40) != want40) { printf("shldq cl: %lx want %lx\n", *(uint64_t*)(p + 40), want40); fails = 1; }
	if (*(uint32_t*)(p + 56) != rotr32(0x0F0F0F0FU, 11)) { printf("shrdl cl: %x want %x\n", *(uint32_t*)(p + 56), rotr32(0x0F0F0F0FU, 11)); fails = 1; }
	if (*(uint64_t*)(p + 64) != 0x1111111111111111UL || *(uint64_t*)(p + 72) != 0x2222222222222222UL) {
		printf("pressure clobbered\n"); fails = 1;
	}
	free(p);
	if (fails)
		return 1;
	printf("shldshrd att ok\n");
	return 0;
}
