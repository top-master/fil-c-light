#include <sys/timex.h>
#include <time.h>
#include <errno.h>
#include "syscall.h"

int clock_adjtime (clockid_t clock_id, struct timex *utx)
{
        return zsys_clock_adjtime(clock_id, utx);
}
