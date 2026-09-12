int foo(int** p, int* r)
{
    int* a = p[0];
    p[2] = r;
    int* b = p[1];
    return (a ? *a : 42) + (b ? *b : 666);
}

