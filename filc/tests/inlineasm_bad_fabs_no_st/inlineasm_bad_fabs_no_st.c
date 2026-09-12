int main(void)
{
    asm volatile("fabs" : : : "fpsr");
    return 0;
}
