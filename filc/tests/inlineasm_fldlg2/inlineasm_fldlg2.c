int main(void)
{
    double a = 0.0;
    asm volatile("fldlg2" : "=t"(a) : : "fpsr");
    return 0;
}
