#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void deint2(void* in, void* out);
void deint3(void* in, void* out);
void deint4(void* in, void* out);
void int2(void* in, void* out);
void int4(void* in, void* out);
void repb(void* in, void* out);
void lane3(void* in, void* out);
void post2(void* in, void* out, long step);

static int check(const char* name, const unsigned char* got, const unsigned char* want, int n)
{
    if (memcmp(got, want, n)) {
        printf("ldmulti BAD %s\n", name);
        return 1;
    }
    return 0;
}

int main()
{
    int bad = 0, i;
    unsigned char in48[48], in64[64], out[64], want[64];

    for (i = 0; i < 32; i++) want[i] = 0;
    unsigned char* p32 = malloc(32);
    unsigned char* o32 = malloc(32);
    for (i = 0; i < 32; i++) p32[i] = (unsigned char)i;
    memset(o32, 0, 32);
    deint2(p32, o32);
    for (i = 0; i < 16; i++) {
        want[i] = (unsigned char)(2 * i);
        want[16 + i] = (unsigned char)(2 * i + 1);
    }
    bad |= check("deint2", o32, want, 32);

    /* int2 interleave of {0..15} and {100..115} -> 0,100,1,101,... */
    for (i = 0; i < 16; i++) {
        p32[i] = (unsigned char)i;
        p32[16 + i] = (unsigned char)(100 + i);
    }
    memset(o32, 0, 32);
    int2(p32, o32);
    for (i = 0; i < 16; i++) {
        want[2 * i] = (unsigned char)i;
        want[2 * i + 1] = (unsigned char)(100 + i);
    }
    bad |= check("int2", o32, want, 32);

    /* ld1r replicate + lane load + post-index on the same 32B object */
    memset(o32, 0, 32);
    repb(p32, o32);
    for (i = 0; i < 16; i++) want[i] = 0;
    memset(o32 + 16, 0, 16);
    bad |= check("repb", o32, want, 16);

    memset(o32, 0xAA, 32);
    lane3(p32, o32);
    for (i = 0; i < 16; i++) want[i] = 0;
    want[3] = 0;
    bad |= check("lane3", o32, want, 16);

    for (i = 0; i < 32; i++) p32[i] = (unsigned char)(i * 3 + 1);
    memset(o32, 0, 32);
    post2(p32, o32, 16);
    for (i = 0; i < 32; i++) want[i] = (unsigned char)(i * 3 + 1);
    bad |= check("post2", o32, want, 32);
    free(p32);
    free(o32);

    unsigned char* p48 = malloc(48);
    unsigned char* o48 = malloc(48);
    for (i = 0; i < 48; i++) in48[i] = (unsigned char)(i * 5 + 2);
    memcpy(p48, in48, 48);
    memset(o48, 0, 48);
    deint3(p48, o48);
    for (i = 0; i < 16; i++) {
        want[i] = in48[3 * i];
        want[16 + i] = in48[3 * i + 1];
        want[32 + i] = in48[3 * i + 2];
    }
    bad |= check("deint3", o48, want, 48);
    free(p48);
    free(o48);

    unsigned char* p64 = malloc(64);
    unsigned char* o64 = malloc(64);
    for (i = 0; i < 64; i++) in64[i] = (unsigned char)(i * 7 + 1);
    memcpy(p64, in64, 64);
    memset(o64, 0, 64);
    deint4(p64, o64);
    for (i = 0; i < 16; i++) {
        want[i] = in64[4 * i];
        want[16 + i] = in64[4 * i + 1];
        want[32 + i] = in64[4 * i + 2];
        want[48 + i] = in64[4 * i + 3];
    }
    bad |= check("deint4", o64, want, 64);

    /* st4 .4s of word vectors {0..3},{4..7},{8..11},{12..15}:
       out[4k+r] = 4r + k */
    unsigned* w64 = (unsigned*)p64;
    for (i = 0; i < 16; i++) w64[i] = (unsigned)i;
    memset(o64, 0, 64);
    int4(p64, o64);
    unsigned* wo = (unsigned*)o64;
    for (i = 0; i < 16; i++) {
        if (wo[i] != (unsigned)(4 * (i % 4) + i / 4)) {
            printf("ldmulti BAD int4\n");
            bad = 1;
            break;
        }
    }
    free(p64);
    free(o64);

    if (bad)
        return 1;
    printf("ldmulti ok\n");
    return 0;
}
