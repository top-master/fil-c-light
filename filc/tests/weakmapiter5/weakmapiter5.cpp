#include <stdfil.h>
#include <stdlib.h>
#include <vector>
#include <unordered_set>

using namespace std;

struct foo {
    foo() = default;

    foo(int x): x(x) { }
    
    int x { 0 };
};

int main(int argc, char** argv)
{
    for (size_t count = 100; count--;) {
        vector<foo*> keys;
        zweak_map* map = zweak_map_new();

        for (int index = 1000; index--;) {
            foo* key = new foo(index);
            keys.push_back(key);
            zweak_map_set(map, key, new foo(index * 666));
        }

        for (int index = 1000; index--;)
            zweak_map_set(map, new foo(index + 1000), new foo(index * 1410));

        zweak_map_iter* iter = zweak_map_get_iter(map);
        unordered_set<int> seen_live;
        unordered_set<int> seen_dead;
        while (zweak_map_iter_next(iter)) {
            foo* key = static_cast<foo*>(zweak_map_iter_key(iter));
            foo* value = static_cast<foo*>(zweak_map_iter_value(iter));
            ZASSERT(key->x >= 0);
            ZASSERT(key->x < 2000);
            if (key->x < 1000) {
                ZASSERT(value->x == key->x * 666);
                ZASSERT(!seen_live.count(value->x));
                seen_live.insert(value->x);
            } else {
                ZASSERT(value->x == (key->x - 1000) * 1410);
                ZASSERT(!seen_dead.count(value->x));
                seen_dead.insert(value->x);
            }
        }
        ZASSERT(seen_live.size() == 1000);
        ZASSERT(seen_dead.size() <= 1000);
    }

    return 0;
}

