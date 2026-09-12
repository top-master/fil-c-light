int main(void)
{
    double a = 1.0;
    double b = 2.0;
    asm volatile("fcompp" : : "t"(a), "u"(b) : "fpsr", "st");
    return 0;
}
