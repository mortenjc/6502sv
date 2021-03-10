// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for memory address multiplexer
//===----------------------------------------------------------------------===//

#include <pcounter.h>
#include <pcounter_common_types.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class TestCase {
public:
  std::string name;
  uint8_t rst;
  uint8_t ps;
  uint16_t pc_in;
  uint16_t exp_pc;
};

using ps = pcounter_common_types::ps_t;
std::vector<TestCase> tests {
  {"hold", 1, ps::HOLD, 0xAAAA, 0x0000},
  {"inc",  1, ps::INC,  0xAAAA, 0x0001},
  {"abs",  1, ps::ABS,  0xAAAA, 0xAAAA},
  {"rel",  1, ps::REL,  0xAAAA, 0xFFFF},
};

class PCTest: public ::testing::Test {
protected:
  pcounter * pc;

  void SetUp( ) {
    pc = new pcounter;
    pc->rst = 0;
    pc->eval();
  }

  void TearDown( ) {
    pc->final();
    delete pc;
  }
};


TEST_F(PCTest, Initial) {
  ASSERT_EQ(pc->pc_in, 0);
  ASSERT_EQ(pc->pc_out, 0);
}

TEST_F(PCTest, AddrSelect) {
  for (auto & test : tests) {
    printf("Executing test %s\n", test.name.c_str());
    pc->ps = test.ps;
    pc->rst = test.rst;
    pc->pc_in = test.pc_in;
    pc->eval();

    pc->clk = 1;
    pc->eval();

    pc->clk = 0;
    pc->eval();

    ASSERT_EQ(pc->pc_out, test.exp_pc);
  }
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
