int main(void)
{
    double a = 0.0;
    asm volatile("fldl2e" : "=t"(a) : : "fpsr");
    return 0;
}
