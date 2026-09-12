#include <stdio.h>
#include <string.h>

void sha256_block_shaext(unsigned state[8], const unsigned char* in, unsigned long num);

int main()
{
	/* SHA-256 initial state */
	unsigned state[8] = {
		0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
		0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
	};
	/* padded "abc" block (64 bytes) */
	unsigned char block[64] = { 0x61, 0x62, 0x63, 0x80 };
	block[63] = 0x18;   /* 24 bits, big-endian length */
	sha256_block_shaext(state, block, 1);
	static const unsigned want[8] = {
		0xba7816bf, 0x8f01cfea, 0x414140de, 0x5dae2223,
		0xb00361a3, 0x96177a9c, 0xb410ff61, 0xf20015ad
	};
	int bad = 0;
	for (int i = 0; i < 8; i++) {
		if (state[i] != want[i]) {
			printf("state[%d] = %08x, want %08x\n", i, state[i], want[i]);
			bad = 1;
		}
	}
	if (bad)
		return 1;
	printf("shani att ok\n");
	return 0;
}
