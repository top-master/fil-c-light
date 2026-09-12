#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

void ts_qb(void* out, const void* in);
void ts_usqb(void* out, const void* in);
void ts_sqb(void* out, const void* in);
void ts_dw(void* out, const void* in);
void ts_wb(void* out, const void* in);

#define N 64

static char* fresh_buf(void)
{
    char* buf = malloc(N);
    if (!buf)
        exit(1);
    memset(buf, 0xAA, N);
    return buf;
}

/* bytes [0, off) must be untouched sentinel; [off, off+len) must match expect. */
static int check(const char* buf, int off, int len, const uint8_t* expect, const char* what)
{
    int i;
    for (i = 0; i < off; i++) {
        if ((uint8_t)buf[i] != 0xAA) {
            printf("%s: byte %d clobbered (%02x)\n", what, i, (uint8_t)buf[i]);
            return 1;
        }
    }
    for (i = 0; i < len; i++) {
        if ((uint8_t)buf[off + i] != expect[i]) {
            printf("%s: byte %d: got %02x want %02x\n", what, off + i,
                   (uint8_t)buf[off + i], expect[i]);
            return 1;
        }
    }
    return 0;
}

int main()
{
    int i;

    /* vpmovqb: plain truncation, low byte of each qword. */
    uint64_t qsrc[8];
    for (i = 0; i < 8; i++)
        qsrc[i] = 0xA0B0C0D0E0F00000ULL | (uint64_t)(i * 37 + 3);
    uint8_t qexp[8];
    for (i = 0; i < 8; i++)
        qexp[i] = (uint8_t)qsrc[i];
    char* buf = fresh_buf();
    ts_qb(buf, qsrc);
    if (check(buf, 56, 8, qexp, "vpmovqb"))
        return 1;

    /* vpmovusqb: source read as UNSIGNED, saturated to 255 (hw-verified:
       256 -> 255, huge -> 255, small values pass through). */
    uint64_t usrc[8] = {0, 1, 255, 256, 1000, 0x7FFFFFFFFFFFFFFFULL,
                        0x8000000000000000ULL, 0xFFFFFFFFFFFFFFFFULL};
    uint8_t uexp[8] = {0, 1, 255, 255, 255, 255, 255, 255};
    buf = fresh_buf();
    ts_usqb(buf, usrc);
    if (check(buf, 56, 8, uexp, "vpmovusqb"))
        return 1;

    /* vpmovsqb: source read as SIGNED, saturated to [-128, 127]. */
    int64_t ssrc[8] = {-1000, -129, -128, -127, -1, 127, 128, 1000};
    uint8_t sexp[8] = {128, 128, 128, 129, 255, 127, 127, 127};
    buf = fresh_buf();
    ts_sqb(buf, ssrc);
    if (check(buf, 56, 8, sexp, "vpmovsqb"))
        return 1;

    /* vpmovdw ymm: low word of each dword. */
    uint32_t dsrc[8] = {0x00000000, 0x00010002, 0xDEADBEEF, 0x12345678,
                        0xFFFF0000, 0x0000FFFF, 0xCAFEBABE, 0x0BADF00D};
    uint8_t dexp[16];
    for (i = 0; i < 8; i++) {
        dexp[2 * i] = (uint8_t)dsrc[i];
        dexp[2 * i + 1] = (uint8_t)(dsrc[i] >> 8);
    }
    buf = fresh_buf();
    ts_dw(buf, dsrc);
    if (check(buf, 48, 16, dexp, "vpmovdw"))
        return 1;

    /* vpmovwb zmm: low byte of each word. */
    uint16_t wsrc[32];
    for (i = 0; i < 32; i++)
        wsrc[i] = 0xC000 | (uint16_t)(i * 7 + 0x31);
    uint8_t wexp[32];
    for (i = 0; i < 32; i++)
        wexp[i] = (uint8_t)wsrc[i];
    buf = fresh_buf();
    ts_wb(buf, wsrc);
    if (check(buf, 32, 32, wexp, "vpmovwb"))
        return 1;

    printf("truncstore ok\n");
    return 0;
}
