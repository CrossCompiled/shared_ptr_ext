#include <iostream>
#include <demo/ptr.hpp>
#include <lecture01/exercise01/SharedPtr.h>

int main() {
    Ptr p(1);
    SharedPtr q(3);
    std::cout << q.val << " Hello, World! " << p.gimme() << std::endl;
    return 0;
}