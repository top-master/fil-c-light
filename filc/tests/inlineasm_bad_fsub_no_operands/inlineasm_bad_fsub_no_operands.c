int main(void)
{
    asm volatile("fsub" : : : "st", "fpsr");
    return 0;
}
