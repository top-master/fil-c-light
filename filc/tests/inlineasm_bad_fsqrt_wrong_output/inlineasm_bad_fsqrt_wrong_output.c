int main(void)
{
    double in = 4.0;
    double out;
    asm volatile("fsqrt" : "=u"(out) : "t"(in));
    return 0;
}
