#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Pins the real aesni-mb generator artifact
// (projects/openssl-3.6.4/crypto/aes/asm/aesni-mb-x86_64.pl): the
// hand-written model suites (sarcasm-mb-sink4x-att, sarcasm-mb-sink8x-att,
// sarcasm-mb-sink32-oob-att, ...) validate model .s files carrying their
// own `.comm ...,32`, so a regression of the .pl itself -- sink back to
// 4096 bytes, or loop-head `leaq` back to the unslid bare-base form --
// would stay green. This test reads the .pl source as text and fails on
// either regression. It needs no built openssl (source text only) and no
// perl (no generation); path candidates cover the run-tests working
// directory (the repo root) plus the container checkout paths, with a
// FILC_REPO_ROOT override for manual negative testing:
//   FILC_REPO_ROOT=/tmp/mutated filc/test-output/sarcasm-mb-pl-sink-att/sarcasm-mb-pl-sink-att
// must fail after `sed -e 's/aesni_mb_sink,32/aesni_mb_sink,4096/' \
//   -e 's/aesni_mb_sink+16/aesni_mb_sink/'`.

static const char *pl_rel =
    "projects/openssl-3.6.4/crypto/aes/asm/aesni-mb-x86_64.pl";

static int failures = 0;

static void check(int cond, const char *what) {
    if (!cond) {
        printf("BAD %s\n", what);
        failures++;
    }
}

static char *read_file(const char *path) {
    FILE *f = fopen(path, "rb");
    if (!f)
        return NULL;
    fseek(f, 0, SEEK_END);
    long len = ftell(f);
    fseek(f, 0, SEEK_SET);
    if (len < 0 || len > (1 << 26)) {
        fclose(f);
        return NULL;
    }
    char *buf = malloc((size_t)len + 1);
    if (!buf) {
        fclose(f);
        return NULL;
    }
    size_t got = fread(buf, 1, (size_t)len, f);
    fclose(f);
    buf[got] = '\0';
    return buf;
}

static int count_occurrences(const char *hay, const char *needle) {
    int n = 0;
    size_t nlen = strlen(needle);
    const char *p = hay;
    while ((p = strstr(p, needle)) != NULL) {
        n++;
        p += nlen;
    }
    return n;
}

int main(void) {
    char pathbuf[4096];
    const char *env = getenv("FILC_REPO_ROOT");
    const char *candidates[4];
    int ncand = 0;
    if (env && env[0]) {
        snprintf(pathbuf, sizeof(pathbuf), "%s/%s", env, pl_rel);
        candidates[ncand++] = pathbuf;
    }
    candidates[ncand++] = pl_rel;
    candidates[ncand++] = "/fil-c/projects/openssl-3.6.4/crypto/aes/asm/aesni-mb-x86_64.pl";
    candidates[ncand++] = "/home/pizlo/Programs/fil-c-4/projects/openssl-3.6.4/crypto/aes/asm/aesni-mb-x86_64.pl";

    char *src = NULL;
    for (int i = 0; i < ncand; i++) {
        src = read_file(candidates[i]);
        if (src) {
            printf("checking %s\n", candidates[i]);
            break;
        }
    }
    if (!src) {
        printf("BAD cannot open aesni-mb-x86_64.pl (tried");
        for (int i = 0; i < ncand; i++)
            printf(" %s;", candidates[i]);
        printf(")\n");
        return 1;
    }

    // 32-byte sink object, not the old 4096-byte one.
    check(count_occurrences(src, "aesni_mb_sink,32") >= 1, "sink .comm size 32");
    check(count_occurrences(src, "aesni_mb_sink,4096") == 0, "no 4096-byte sink");
    // Constant-address slide at both 4x loop heads (enc + dec): the lea
    // must carry the +16 bias ...
    check(count_occurrences(src, "aesni_mb_sink+16") >= 2, "slid loop-head leaq x2");
    // ... and the matching `sub $offset,$sink` rebase must still follow it.
    check(count_occurrences(src, "sub\t$offset,$sink") >= 2, "slide sub x2");
    // The shared sink is only sound with the disjoint load/store windows
    // the audit comment enumerates; make sure the audit is still there.
    check(count_occurrences(src, "Union of all windows = [base,base+32)") >= 1,
        "sink window audit comment");

    free(src);
    if (failures) {
        printf("mb pl sink BAD\n");
        return 1;
    }
    printf("mb pl sink ok\n");
    return 0;
}
