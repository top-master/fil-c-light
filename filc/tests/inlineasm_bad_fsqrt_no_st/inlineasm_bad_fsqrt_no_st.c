int main(void)
{
    asm volatile("fsqrt" : : : "fpsr");
    return 0;
}
