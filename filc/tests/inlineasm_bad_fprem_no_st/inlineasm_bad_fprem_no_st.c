int main(void)
{
    asm volatile("fprem" : : : "fpsr");
    return 0;
}
