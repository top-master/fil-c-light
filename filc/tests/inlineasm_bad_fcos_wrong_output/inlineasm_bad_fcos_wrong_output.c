int main(void)
{
    double in = 1.0;
    double out;
    asm volatile("fcos" : "=u"(out) : "t"(in));
    return 0;
}
