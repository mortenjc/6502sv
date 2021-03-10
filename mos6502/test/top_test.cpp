// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for instruction register
//===----------------------------------------------------------------------===//

#include <top.h>
#include <top_common_types.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class TestCase {
public:
  std::string name;
};

std::vector<TestCase> tests {
};

class TopTest: public ::testing::Test {
protected:
  top * itop;

  void SetUp( ) {
    itop = new top;
    itop->eval();
  }

  void TearDown( ) {
    itop->final();
    delete itop;
  }
};


TEST_F(TopTest, Initial) {
  ASSERT_EQ(0, 0);
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
