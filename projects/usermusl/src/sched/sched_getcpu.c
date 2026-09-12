#define _GNU_SOURCE
#include <errno.h>
#include <sched.h>
#include "syscall.h"
#include "atomic.h"

int sched_getcpu(void)
{
        return zsys_sched_getcpu();
}
