// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for instruction register
//===----------------------------------------------------------------------===//

#include <instreg.h>
#include <instreg_common_types.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class TestCase {
public:
  std::string name;
  uint8_t data_in;
  uint8_t il;
  uint8_t expected_data;
};

using il = instreg_common_types::il_t;
std::vector<TestCase> tests {
  {"load1",   0xAA, il::LOAD,   0xAA},
  {"noload1", 0xBB, il::NOLOAD, 0xAA}
};

class ILDTest: public ::testing::Test {
protected:
  instreg * ireg;

  void SetUp( ) {
    ireg = new instreg;
    ireg->data_in = 0;
    ireg->il = 0;
    ireg->eval();
  }

  void TearDown( ) {
    ireg->final();
    delete ireg;
  }
};


TEST_F(ILDTest, Initial) {
  ASSERT_EQ(ireg->data_in, 0);
}

TEST_F(ILDTest, LoadNoLoad) {
  for (auto & test : tests) {
    printf("Executing test %s\n", test.name.c_str());
    ireg->il = test.il;
    ireg->data_in = test.data_in;
    ireg->eval();

    ASSERT_EQ(ireg->opc_out, test.expected_data);
  }
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
