int main(void)
{
    double in = 2.3;
    double out;
    asm volatile("frndint" : "=u"(out) : "t"(in));
    return 0;
}
