int main(void)
{
    double a = 0.0;
    asm volatile("fldz" : "=t"(a) : : "fpsr");
    return 0;
}
