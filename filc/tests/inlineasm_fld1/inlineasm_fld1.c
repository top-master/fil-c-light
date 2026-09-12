int main(void)
{
    double a = 0.0;
    asm volatile("fld1" : "=t"(a) : : "fpsr");
    return 0;
}
