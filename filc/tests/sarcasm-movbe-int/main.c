#include <stdio.h>
#include <stdlib.h>

void movbe_ops(unsigned char* p);

int main()
{
	unsigned char* p = calloc(7, 8);
	if (!p)
		return 1;
	*(unsigned long*)p = 0x0123456789ABCDEFUL;
	*(unsigned long*)(p + 8) = 0;
	*(unsigned*)(p + 16) = 0x11223344U;
	*(unsigned short*)(p + 24) = 0x7788;
	*(unsigned long*)(p + 32) = 0xFFEEDDCCBBAA9988UL;
	movbe_ops(p);
	int fails = 0;
	if (*(unsigned long*)p != 0xEFCDAB8967452301UL) {
		printf("movbeq load: %lx\n", *(unsigned long*)p); fails = 1;
	}
	if (*(unsigned long*)(p + 8) != 0x0123456789ABCDEFUL) {
		printf("movbeq store: %lx\n", *(unsigned long*)(p + 8)); fails = 1;
	}
	if (*(unsigned*)(p + 16) != 0x44332211U) {
		printf("movbel load: %x\n", *(unsigned*)(p + 16)); fails = 1;
	}
	if (*(unsigned*)(p + 20) != 0x11223344U) {
		printf("movbel store: %x\n", *(unsigned*)(p + 20)); fails = 1;
	}
	if (*(unsigned*)(p + 24) != 0x77888877UL) {
		printf("movbew load: %x\n", *(unsigned*)(p + 24)); fails = 1;
	}
	if (*(unsigned short*)(p + 26) != 0x7788U) {
		printf("movbew store: %x\n", *(unsigned short*)(p + 26)); fails = 1;
	}
	if (*(unsigned long*)(p + 32) != 0x8899AABBCCDDEEFFUL) {
		printf("movbeq pressure load: %lx\n", *(unsigned long*)(p + 32)); fails = 1;
	}
	if (*(unsigned long*)(p + 40) != 0x1111111111111111UL
		|| *(unsigned long*)(p + 48) != 0x2222222222222222UL) {
		printf("pressure clobbered\n"); fails = 1;
	}
	free(p);
	if (fails)
		return 1;
	printf("movbe int ok\n");
	return 0;
}
