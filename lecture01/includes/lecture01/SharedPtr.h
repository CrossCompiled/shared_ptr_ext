//
// Created by Kalle Møller on 31/08/16.
//

#ifndef SHARED_PTR_EXT_SHAREDPTR_H
#define SHARED_PTR_EXT_SHAREDPTR_H

class SharedPtr {
public:
    SharedPtr(int i) {
        val = i;
    }
    int val;
};

#endif //SHARED_PTR_EXT_SHAREDPTR_H
