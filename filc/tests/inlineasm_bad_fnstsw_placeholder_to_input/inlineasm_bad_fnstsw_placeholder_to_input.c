int main(void)
{
    unsigned short sw;
    int x = 0;
    asm volatile("fnstsw %1" : "=a"(sw) : "r"(x) : "fpsr");
    return 0;
}
