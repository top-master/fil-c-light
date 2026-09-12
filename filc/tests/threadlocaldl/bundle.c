static int z = 47;

static __thread int x = 1410;
static __thread int* y = &z;

void setx(int value)
{
    x = value;
}

int getx(void)
{
    return x;
}

void sety(int* value)
{
    y = value;
}

int* gety(void)
{
    return y;
}

