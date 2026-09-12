#include <atomic>
#include <stdfil.h>

int v = 42;

struct intptr {
  int *p;
};

std::atomic<intptr> p = intptr { &v };

int main() {
  intptr loaded_p = p.load(std::memory_order_acquire);
  *loaded_p.p = 43;
  zcompiler_fence();
  ZASSERT(v == 43);
  return 0;
}
