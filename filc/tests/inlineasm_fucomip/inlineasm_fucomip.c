int main(void)
{
    double a = 1.0;
    double b = 2.0;
    asm volatile("fucomip" : : "t"(a), "u"(b) : "cc", "st", "fpsr");
    return 0;
}
