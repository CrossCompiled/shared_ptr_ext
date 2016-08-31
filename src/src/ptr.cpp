#include <demo/ptr.hpp>

Ptr::Ptr(int i)
{
    val = i;
};

int Ptr::gimme()
{
    return val;
};
