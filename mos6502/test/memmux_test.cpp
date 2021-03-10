// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for memory address multiplexer
//===----------------------------------------------------------------------===//

#include <memmux.h>
#include <memmux_common_types.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class TestCase {
public:
  std::string name;
  uint8_t mm;
  uint16_t pc_in;
  uint16_t addr_in;
  uint16_t expected_data;
};

using mm = memmux_common_types::mm_t;
std::vector<TestCase> tests {
  {"pcsel",   mm::PC_ADDR, 0x1234, 0x2345, 0x1234},
  {"adsel",   mm::A_ADDR,  0x1234, 0x2345, 0x2345},
};

class MMUXTest: public ::testing::Test {
protected:
  memmux * mmx;

  void SetUp( ) {
    mmx = new memmux;
    mmx->pc_in = 0;
    mmx->addr_in = 0;
    mmx->mm = 0;
    mmx->eval();
  }

  void TearDown( ) {
    mmx->final();
    delete mmx;
  }
};


TEST_F(MMUXTest, Initial) {
  ASSERT_EQ(mmx->pc_in, 0);
  ASSERT_EQ(mmx->addr_in, 0);
}

TEST_F(MMUXTest, AddrSelect) {
  for (auto & test : tests) {
    printf("Executing test %s\n", test.name.c_str());
    mmx->mm = test.mm;
    mmx->pc_in = test.pc_in;
    mmx->addr_in = test.addr_in;
    mmx->eval();

    ASSERT_EQ(mmx->addr_out, test.expected_data);
  }
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
