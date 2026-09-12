int main(void)
{
    asm volatile("fnstsw");
    return 0;
}
