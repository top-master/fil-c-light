#include <sys/fsuid.h>
#include "syscall.h"

int setfsgid(gid_t gid)
{
	return zsys_setfsgid(gid);
}
