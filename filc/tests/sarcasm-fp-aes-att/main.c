#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* in = [key(16) | plaintext(16)]; out = [ciphertext(16) | recovered(16)] */
void aes_roundtrip(void* in, void* out);

static const unsigned char expected_ct[16] = {
    0x29, 0xc3, 0x50, 0x5f, 0x57, 0x14, 0x20, 0xf6,
    0x40, 0x22, 0x99, 0xb3, 0x1a, 0x02, 0xd7, 0x3a
};

int main()
{
    unsigned char* in = malloc(32);
    unsigned char* out = malloc(32);
    if (!in || !out)
        return 1;
    memcpy(in, "Thats my Kung Fu", 16);      /* classic AES-NI whitepaper key */
    memcpy(in + 16, "Two One Nine Two", 16);  /* classic AES-NI whitepaper block */
    memset(out, 0, 32);
    aes_roundtrip(in, out);
    if (memcmp(out, expected_ct, 16)) {
        printf("aes BAD ciphertext\n");
        return 1;
    }
    if (memcmp(out + 16, in + 16, 16)) {
        printf("aes BAD roundtrip\n");
        return 1;
    }
    printf("aes ok\n");
    return 0;
}
