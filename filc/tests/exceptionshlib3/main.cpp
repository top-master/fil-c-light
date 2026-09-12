void bar();

__attribute__((visibility("default"))) int main()
{
    bar();
    return 0;
}

