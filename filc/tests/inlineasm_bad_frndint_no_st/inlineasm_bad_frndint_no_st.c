int main(void)
{
    asm volatile("frndint" : : : "fpsr");
    return 0;
}
