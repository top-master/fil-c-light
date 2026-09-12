#define _GNU_SOURCE 1
#include <sys/mman.h>
#include "syscall.h"

int memfd_create(const char *name, unsigned flags)
{
	return zsys_memfd_create(name, flags);
}
