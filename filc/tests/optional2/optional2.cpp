#include <stdfil.h>
#include <optional>

struct Stuff {
public:
    const char* a;
    const char* b;
};

struct Thingy {
    void setStuff(Stuff stuff)
    {
        haveStuff = true;
        u.stuff = stuff;
    }
    
    std::optional<Stuff> getStuff()
    {
        if (haveStuff)
            return u.stuff;
        return std::nullopt;
    }
    
    bool haveStuff;
    union {
        Stuff stuff;
        const char* other;
    } u;
};

static void blah(std::optional<Stuff> stuff)
{
    ZASSERT(!strcmp(stuff->a, "hello"));
    ZASSERT(!strcmp(stuff->b, "world"));
}

__attribute__((noinline)) void whatever(Thingy& thingy)
{
    if (thingy.haveStuff)
        blah(thingy.getStuff());
}

int main()
{
    Stuff stuff;
    stuff.a = "hello";
    stuff.b = "world";
    Thingy thingy;
    thingy.setStuff(stuff);
    whatever(thingy);
    return 0;
}

