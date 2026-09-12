int foo(int** p, int** q, int* r)
{
    int* a = p[0];
    *q = r;
    int* b = p[1];
    return (a ? *a : 0) + (b ? *b : 0);
}

