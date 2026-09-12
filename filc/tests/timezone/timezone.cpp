#include <chrono>
#include <iostream>
#include <exception>

using namespace std;

int main()
{
    try {
        cout << chrono::current_zone()->name() << endl;
    } catch (const exception& e) {
        cout << e.what() << endl;
    }
    return 0;
}
