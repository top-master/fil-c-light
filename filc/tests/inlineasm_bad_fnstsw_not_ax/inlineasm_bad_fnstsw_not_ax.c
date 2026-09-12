int main(void)
{
    unsigned short sw;
    asm volatile("fnstsw %0" : "=r"(sw));
    return 0;
}
