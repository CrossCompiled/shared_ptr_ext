//
// Created by Kalle Møller on 31/08/16.
//

#ifndef SHARED_PTR_EXT_SHAREDPTR_H
#define SHARED_PTR_EXT_SHAREDPTR_H

namespace lecture01 {
    namespace exercise01 {
        class SharedPtr {
        public:
            SharedPtr(int i) {
                val = i;
            }
            int val;
        };
    }
}


#endif //SHARED_PTR_EXT_SHAREDPTR_H
