// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief 
//===----------------------------------------------------------------------===//

#include <cpu.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>
#include <math.h>


class CPUTest: public ::testing::Test {
protected:
  cpu * c;

  void clock_cycles(int n) {
    for (int i = 0; i < n; i++) {
      c->clk = 1;
      c->eval();
      c->clk = 0;
      c->eval();
    }
  }

  void SetUp( ) {
    c = new cpu;
  }

  void TearDown( ) {
    c->final();
    delete c;
  }
};


TEST_F(CPUTest, InitialState) {
  ASSERT_EQ(c->PC, 0);
}

TEST_F(CPUTest, OneClock) {
  clock_cycles(10);
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  VerilatedCov::write("logs/cpu.dat");
  return res;
}
