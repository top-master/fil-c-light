#include <sys/fsuid.h>
#include "syscall.h"

int setfsuid(uid_t uid)
{
	return zsys_setfsuid(uid);
}
