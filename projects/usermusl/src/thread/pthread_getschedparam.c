#include "pthread_impl.h"
#include "lock.h"

int pthread_getschedparam(pthread_t t, int *restrict policy, struct sched_param *restrict param)
{
	int r;
	sigset_t set;
	__block_app_sigs(&set);
	LOCK(t->killlock);
	if (!t->tid) {
		r = ESRCH;
	} else {
                int saved_errno = errno;
                if (!zsys_sched_getparam(t->tid, param)) {
                        int policy_result = zsys_sched_getscheduler(t->tid);
                        ZASSERT(policy_result >= 0);
                        *policy = policy_result;
                        r = 0;
                } else {
                        r = errno;
                }
                errno = saved_errno;
	}
	UNLOCK(t->killlock);
	__restore_sigs(&set);
	return r;
}
