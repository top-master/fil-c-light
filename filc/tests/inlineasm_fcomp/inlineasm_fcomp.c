int main(void)
{
    double a = 1.0;
    double b = 2.0;
    asm volatile("fcomp" : : "t"(a), "u"(b) : "fpsr", "st");
    return 0;
}
