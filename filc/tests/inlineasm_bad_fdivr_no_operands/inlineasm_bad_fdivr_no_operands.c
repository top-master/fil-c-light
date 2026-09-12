int main(void)
{
    asm volatile("fdivr" : : : "st", "fpsr");
    return 0;
}
