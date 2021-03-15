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
// using opc_t = decode_common_types::opc_t;
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

TEST_F(CPUunitTest, ThirtyClocks) {
  clockCycles(40);
  ASSERT_EQ(u->clocks, 39);
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  VerilatedCov::write("logs/ledunit.dat");
  return res;
}
