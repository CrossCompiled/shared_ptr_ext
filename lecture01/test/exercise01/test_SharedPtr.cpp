//
// Created by Kalle Møller on 31/08/16.
//

#include <gtest/gtest.h>
#include <lecture01/exercise01/SharedPtr.h>

using namespace lecture01;

TEST (SquareRootTest, PositiveNos) {
    exercise01::SharedPtr p(1);
    EXPECT_EQ (18, 18);
}