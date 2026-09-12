int main(void)
{
    float f = 3.14f;
    asm volatile("fst %0" : "=m"(f));
    return 0;
}
