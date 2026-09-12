int main(void)
{
    asm volatile("fprem1" : : : "fpsr");
    return 0;
}
