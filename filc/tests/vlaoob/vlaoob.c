int main()
{
    int n = 10;
    int i = 20;
    asm ("" : "+r"(n), "+r"(i));
    int array[n];
    array[i] = 67;
    return 0;
}

