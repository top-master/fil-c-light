/* The root of an installation, found from the binary that holds this code instead of
   from a path written in at build time, so the installation works wherever it is put.

   Both glibcs (yolo and user) compile this file into their libc, which exports it to
   their own programs (iconv, locale, localedef, getconf, ...), and into their loader.
   It is plain C, built by GCC (yolo) and by the Fil-C clang (user) alike; the parts the
   loader runs use only strlen and memcpy of the string functions, the ones it has.  */

#include <dlfcn.h>
#include <limits.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#if IS_IN (rtld)
# include <ldsodefs.h>
#endif

const char *__binary_root (int depth_level);
const char *__binary_root_join (int depth_level, const char *paths);

/* The cached root: the depth it was found for (-1 for none yet), and whether the
   binary's path was unknown, which no depth can change.  The loader never caches an
   unknown path (see binary_root_interp).  Both are read with acquire and written with
   release ordering, after binary_root_path, so a thread that sees the depth also sees
   the path; only depth 1 is ever asked for, so racing writers store the same bytes.  */
static int binary_root_depth = -1;
static int binary_root_unknown;
static char binary_root_path[PATH_MAX];

#if IS_IN (rtld)
/* Returns the PT_INTERP of the program the loader runs (the loader's own file), read
   from the program's headers, which the auxiliary vector names; NULL when there is none
   (the loader run as a program).  The loader reads its tunables, whose ld.so.cache path
   is below the root, before it notes its own name in its link map, so this is the name
   that early.  */
static const char *
binary_root_interp (void)
{
  const ElfW(Phdr) *phdr = NULL;
  size_t phnum = 0;
  if (GLRO(dl_auxv) == NULL)
    return NULL;
  for (const ElfW(auxv_t) *av = GLRO(dl_auxv); av->a_type != AT_NULL; ++av)
    if (av->a_type == AT_PHDR)
      phdr = (const ElfW(Phdr) *) av->a_un.a_val;
    else if (av->a_type == AT_PHNUM)
      phnum = av->a_un.a_val;
  if (phdr == NULL)
    return NULL;
  ElfW(Addr) bias = 0;
  const ElfW(Phdr) *interp = NULL;
  for (size_t i = 0; i < phnum; ++i)
    if (phdr[i].p_type == PT_PHDR)
      bias = (ElfW(Addr)) phdr - phdr[i].p_vaddr;
    else if (phdr[i].p_type == PT_INTERP)
      interp = &phdr[i];
  return interp == NULL ? NULL : (const char *) (bias + interp->p_vaddr);
}
#endif

/* Stores in BUF (of SIZE bytes) the absolute file of the binary that holds this code;
   returns 0 when that is unknown.  The loader cannot ask itself, but it knows its own
   name: the PT_INTERP of the program it runs (see binary_root_interp), later kept as
   its l_name.  A libc asks the loader which object holds this code; when that is the
   program itself (a static one, named by argv[0]) and the name has no folder (found
   through PATH), the kernel's /proc/self/exe names it instead.  */
static int
binary_root_file (char *buf, size_t size)
{
  const char *file = NULL;
#if IS_IN (rtld)
  file = _dl_rtld_map.l_name;
  if (file == NULL && _dl_rtld_map.l_libname != NULL)
    file = _dl_rtld_map.l_libname->name;
  if (file == NULL || file[0] != '/')
    file = binary_root_interp ();
#else
  Dl_info self;
  if (__dladdr ((const void *) &__binary_root, &self) && self.dli_fname)
    file = self.dli_fname;
# ifdef SHARED
  if (file == NULL || strchr (file, '/') == NULL)
# endif
    {
      ssize_t n = __readlink ("/proc/self/exe", buf, size - 1);
      if (n <= 0 || buf[0] != '/')
        return 0;
      buf[n] = '\0';
      return 1;
    }
#endif
  if (file == NULL || file[0] == '\0')
    return 0;
  size_t len = 0;
  if (file[0] != '/')
    {
#if IS_IN (rtld)
      return 0;
#else
      /* A relative name is taken from the current folder, unless the program runs
         with raised privileges, whose current folder anyone may have chosen.  */
      if (__libc_enable_secure)
        return 0;
      if (getcwd (buf, size) == NULL || buf[0] != '/')
        return 0;
      len = strlen (buf);
      if (len + 1 >= size)
        return 0;
      buf[len++] = '/';
#endif
    }
  size_t file_len = strlen (file);
  if (len + file_len >= size)
    return 0;
  memcpy (buf + len, file, file_len + 1);
  return 1;
}

/* Cleans the absolute path PATH in place: removes empty and "." components and
   resolves each ".." against the component before it (never above "/").  */
static void
binary_root_clean (char *path)
{
  char *out = path;            /* The cleaned path ends here.  */
  const char *in = path;
  while (*in != '\0')
    {
      while (*in == '/')
        ++in;
      const char *end = in;
      while (*end != '\0' && *end != '/')
        ++end;
      size_t len = end - in;
      if (len == 0 || (len == 1 && in[0] == '.'))
        ;
      else if (len == 2 && in[0] == '.' && in[1] == '.')
        {
          while (out > path && out[-1] != '/')
            --out;
          if (out > path)
            --out;
        }
      else
        {
          /* OUT never passes IN, so a forward copy is safe.  */
          *out++ = '/';
          for (size_t i = 0; i < len; ++i)
            *out++ = in[i];
        }
      in = end;
    }
  if (out == path)
    *out++ = '/';
  *out = '\0';
}

/* Returns the folder DEPTH_LEVEL levels above the folder of the binary that holds this
   code, as a clean absolute path: for 1, $binaryPath/.. (the binary being
   <root>/lib/libc.so, the result is <root>).  Returns NULL when the binary's path is
   unknown.  The result is cached: a call with the same DEPTH_LEVEL returns it at once,
   and a call with another one replaces it (unless the binary's path is unknown).  */
const char *
__binary_root (int depth_level)
{
  if (__atomic_load_n (&binary_root_unknown, __ATOMIC_ACQUIRE))
    return NULL;
  if (depth_level == __atomic_load_n (&binary_root_depth, __ATOMIC_ACQUIRE))
    return binary_root_path;

  char path[PATH_MAX];
  if (! binary_root_file (path, sizeof path))
    {
#if !IS_IN (rtld)
      __atomic_store_n (&binary_root_unknown, 1, __ATOMIC_RELEASE);
#endif
      return NULL;
    }
  /* The binary's folder (the path is absolute: it has a '/'), then DEPTH_LEVEL
     levels up.  */
  size_t len = strlen (path);
  while (path[len - 1] != '/')
    --len;
  path[len] = '\0';
  for (int i = 0; i < depth_level; ++i)
    {
      if (len + 3 >= sizeof path)
        {
          __atomic_store_n (&binary_root_unknown, 1, __ATOMIC_RELEASE);
          return NULL;
        }
      memcpy (path + len, "../", 4);
      len += 3;
    }
  binary_root_clean (path);
  memcpy (binary_root_path, path, strlen (path) + 1);
  __atomic_store_n (&binary_root_depth, depth_level, __ATOMIC_RELEASE);
  return binary_root_path;
}

/* Returns a new string: PATHS with the root DEPTH_LEVEL levels up in place of each '='
   (see __binary_root_join), and sets *ROOT_KNOWN to whether that root was known.  NULL
   when out of memory.  */
static char *
binary_root_join_new (int depth_level, const char *paths, int *root_known)
{
  const char *root = __binary_root (depth_level);
  *root_known = root != NULL;
  size_t root_len = 0, count = 1, len;
  const char *p;
  if (root != NULL && !(root[0] == '/' && root[1] == '\0'))
    root_len = strlen (root);
  for (p = paths; *p != '\0'; ++p)
    if (*p == ':')
      ++count;
  char *result = malloc (strlen (paths) + count * root_len + 1);
  if (result == NULL)
    return NULL;
  char *out = result;
  p = paths;
  for (;;)
    {
      const char *end = p;
      while (*end != '\0' && *end != ':')
        ++end;
      len = end - p;
      if (*end == '\0')
        end = NULL;
      if (len > 0 && p[0] == '=')
        {
          ++p, --len;
          /* An unknown root leaves the path absolute: one that is merely absent,
             never one below the current folder, which anyone may have chosen.  */
          if (root != NULL)
            {
              memcpy (out, root, root_len);
              out += root_len;
            }
        }
      memcpy (out, p, len);
      out += len;
      if (end == NULL)
        break;
      *out++ = ':';
      p = end + 1;
    }
  *out = '\0';
  return result;
}

/* The joined paths already asked for: a list that only grows (an entry is put first with
   a compare-and-swap, so concurrent callers need no lock), as few distinct paths are
   ever asked for.  */
struct binary_root_entry
{
  struct binary_root_entry *next;
  int depth_level;
  const char *result;
  char paths[];                 /* The PATHS asked for.  */
};
static struct binary_root_entry *binary_root_cache;

/* Tells whether the strings A and B are equal.  */
static int
binary_root_equal (const char *a, const char *b)
{
  while (*a != '\0' && *a == *b)
    ++a, ++b;
  return *a == *b;
}

/* Returns PATHS, a path or a ':'-separated list of them, where each one below the root
   is written "=<path from the root>" ("=/lib/gconv"), as GNU ld writes one below its
   sysroot, with the root DEPTH_LEVEL levels up (see __binary_root) in place of each
   '='; when the root is unknown, they stay below "/" ("/lib/gconv").
   Any other path is kept as it is.  The result is cached and shared (never to be
   freed): asking again for the same PATHS and DEPTH_LEVEL, from any caller, returns it
   at once (in the loader, only once the root is known: see binary_root_depth).  NULL
   when out of memory.  */
const char *
__binary_root_join (int depth_level, const char *paths)
{
  struct binary_root_entry *e;
  for (e = __atomic_load_n (&binary_root_cache, __ATOMIC_ACQUIRE); e != NULL; e = e->next)
    if (e->depth_level == depth_level && binary_root_equal (e->paths, paths))
      return e->result;

  int root_known;
  char *result = binary_root_join_new (depth_level, paths, &root_known);
  if (result == NULL)
    return NULL;
#if IS_IN (rtld)
  if (! root_known)
    return result;
#endif
  size_t paths_size = strlen (paths) + 1;
  e = malloc (sizeof *e + paths_size);
  if (e == NULL)
    return result;
  e->depth_level = depth_level;
  e->result = result;
  memcpy (e->paths, paths, paths_size);
  e->next = __atomic_load_n (&binary_root_cache, __ATOMIC_RELAXED);
  while (! __atomic_compare_exchange_n (&binary_root_cache, &e->next, e, 1,
                                        __ATOMIC_RELEASE, __ATOMIC_RELAXED))
    ;
  return result;
}
