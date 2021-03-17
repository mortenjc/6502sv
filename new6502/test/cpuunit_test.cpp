// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief cpu unit
//===----------------------------------------------------------------------===//

#include <cpuunit.h>
#include <cpuunit_common_types.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>
#include <math.h>


// struct TestCase {
// };
//
using state = cpuunit_common_types::state_t;
//
// std::vector<struct TestCase> TestCases {
//
// };



//
// Test harness
//

class CPUunitTest: public ::testing::Test {
protected:
  cpuunit * u;

  void clockCycles(int n) {
    for (int i = 0; i < n; i++) {
      u->clk = 1;
      u->eval();
      u->clk = 0;
      u->eval();
    }
  }

  void SetUp( ) {
    u = new cpuunit;
  }

  void TearDown( ) {
    u->final();
    delete u;
  }
};

//
// Test cases
//

TEST_F(CPUunitTest, Constructor) {
  u->eval();
  ASSERT_EQ(u->PC, 0);
  ASSERT_EQ(u->IR, 0);
  ASSERT_EQ(u->clocks, 0);
}

TEST_F(CPUunitTest, InstrINX) {
  u->state = state::fetch;
  u->PC = 0x0010;
  clockCycles(0x21); // 16 instr * 2 cycles + 1
  ASSERT_EQ(u->X, 16);
  ASSERT_EQ(u->state, state::fetch);
  ASSERT_EQ(u->PC, 0x0020);
}

TEST_F(CPUunitTest, InstrLDXI) {
  u->state = state::fetch;
  u->PC = 0x0030;
  clockCycles(3); // 1 inst
  ASSERT_EQ(u->X, 0xAA);
  ASSERT_EQ(u->state, state::fetch);
  ASSERT_EQ(u->PC, 0x0032);
}

TEST_F(CPUunitTest, InstrMixLDXIandINX) {
  u->state = state::fetch;
  u->PC = 0x0040;
  clockCycles(5); // 2 inst * 2 cycles + 1
  ASSERT_EQ(u->X, 0xBC);
  ASSERT_EQ(u->state, state::fetch);
  ASSERT_EQ(u->PC, 0x0043);
}

TEST_F(CPUunitTest, InstrLDXZP) {
  u->state = state::fetch;
  u->PC = 0x0050;
  clockCycles(4); // 1 inst * 3 cycles + 1
  ASSERT_EQ(u->X, 0xFF);
  ASSERT_EQ(u->state, state::fetch);
  ASSERT_EQ(u->PC, 0x0052);
}



int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  VerilatedCov::write("logs/cpuunit.dat");
  return res;
}
