#include <exception>

using namespace std;

class Exception : public exception {
public:
    Exception() = default;

    const char* what() const throw() override
    {
        return "67";
    }
};

void foo()
{
    throw Exception();
}
