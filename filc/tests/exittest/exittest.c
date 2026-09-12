#include <stdlib.h>

#ifdef __x86_64__
#define GUFF " #"
#else
#define GUFF " //"
#endif

#define FINI(s) __attribute__((__section__(s ",\"aw\",@fini_array" GUFF)))

int counter;

/* void dtor7(void) { */
/*   if (++counter != 7) */
/*     _Exit(7); */
/*   _Exit(0); */
/* } */

/* FINI(".fini_array.lol") void *const kDtor7[] = {dtor7}; */

/* void dtor6(void) { */
/*   if (++counter != 6) */
/*     _Exit(6); */
/* } */

/* FINI(".fini_array") void *const kDtor6[] = {dtor6}; */

/* void dtor5(void) { */
/*   if (++counter != 5) */
/*     _Exit(5); */
/* } */

/* FINI(".fini_array") void *const kDtor5[] = {dtor5}; */

__attribute__((__destructor__)) static void dtor4(void) {
  if (++counter != 4)
    _Exit(4);
  _Exit(0);
}

__attribute__((__destructor__)) static void dtor3(void) {
  if (++counter != 3)
    _Exit(3);
}

static void dtor2(void) {
  if (++counter != 2)
    _Exit(2);
}

static void dtor1(void) {
  if (++counter != 1)
    _Exit(1);
}

int main(void) {
  atexit(dtor2);
  atexit(dtor1);
  return 100;
}
