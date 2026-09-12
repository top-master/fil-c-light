#include <threads.h>
#include "syscall.h"

void thrd_yield()
{
	zsys_sched_yield();
}
