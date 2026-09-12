int main()
{
    int i = 20;
    asm ("" : "+r"(i));
    int array[10];
    array[i] = 67;
    return 0;
}

