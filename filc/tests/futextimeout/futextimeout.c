#include <errno.h>
#include <linux/futex.h>
#include <stdfil.h>
#include <stdint.h>
#include <sys/syscall.h>
#include <time.h>
#include <unistd.h>

struct timespec now_plus(int clock_id, struct timespec addend)
{
    struct timespec result;
    clock_gettime(clock_id, &result);
    result.tv_sec += addend.tv_sec;
    result.tv_nsec += addend.tv_nsec;
    if (result.tv_nsec >= 1000000000) {
        result.tv_sec++;
        result.tv_nsec -= 1000000000;
    }
    return result;
}

int main()
{
    struct timespec ten_ms = {0, 10000000};
    uint32_t fw = 0;

    /* These take a relative timespec. */
    ZASSERT(syscall(SYS_futex, &fw, FUTEX_WAIT, 0, &ten_ms, 0, 0) == -1);
    ZASSERT(errno == ETIMEDOUT);
    ZASSERT(syscall(SYS_futex, &fw, FUTEX_WAIT | FUTEX_CLOCK_REALTIME, 0, &ten_ms, 0, 0) == -1);
    ZASSERT(errno == ETIMEDOUT);

    /* These take an absolute timespec. */
    struct timespec timeout = now_plus(CLOCK_MONOTONIC, ten_ms);
    ZASSERT(syscall(SYS_futex, &fw, FUTEX_WAIT_BITSET, 0, &timeout, 0, FUTEX_BITSET_MATCH_ANY) == -1);
    ZASSERT(errno == ETIMEDOUT);
    timeout = now_plus(CLOCK_REALTIME, ten_ms);
    ZASSERT(syscall(SYS_futex, &fw, FUTEX_WAIT_BITSET | FUTEX_CLOCK_REALTIME, 0, &timeout, 0,
                FUTEX_BITSET_MATCH_ANY)
        == -1);
    ZASSERT(errno == ETIMEDOUT);
}
