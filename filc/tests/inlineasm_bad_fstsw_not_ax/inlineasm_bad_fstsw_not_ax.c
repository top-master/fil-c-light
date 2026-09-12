int main(void)
{
    unsigned short sw;
    asm volatile("fstsw %0" : "=r"(sw));
    return 0;
}
