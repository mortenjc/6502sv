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


using state = cpuunit_common_types::state_t;

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
    u->debug = 1;
    u->rst = 1; // No reset
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

TEST_F(CPUunitTest, InstrLDXI_ZFlagSet) {
  u->state = state::fetch;
  u->PC = 0x0070;
  clockCycles(3); // 1 inst
  ASSERT_EQ(u->X, 0x00);
  ASSERT_EQ(u->state, state::fetch);
  ASSERT_EQ(u->PC, 0x0072);
  ASSERT_EQ(u->S, 0x02); // Z
}

TEST_F(CPUunitTest, InstrLDXI_ZFlagClear) {
  u->state = state::fetch;
  u->PC = 0x0070;
  clockCycles(5); // 1 inst
  ASSERT_EQ(u->X, 0x01);
  ASSERT_EQ(u->state, state::fetch);
  ASSERT_EQ(u->PC, 0x0074);
  ASSERT_EQ(u->S, 0x00); // Z
}

TEST_F(CPUunitTest, InstrINXTo0) {
  u->state = state::fetch;
  u->PC = 0x0098;
  clockCycles(5); //
  ASSERT_EQ(u->X, 0x00);
  ASSERT_EQ(u->state, state::fetch);
  ASSERT_EQ(u->PC, 0x009B);
  ASSERT_EQ(u->S, 0x02); // Zero
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

TEST_F(CPUunitTest, InstrJMPA) {
  u->state = state::fetch;
  u->PC = 0x0060;
  clockCycles(4); // 1 inst * 3 cycles + 1
  printf("PC: %04x: addrlo: $%02x, addrhi: $%02x\n", u->PC, u->addrlo, u->addrhi);
  ASSERT_EQ(u->state, state::fetch);
  ASSERT_EQ(u->PC, 0x0050);
}

TEST_F(CPUunitTest, InstrBEQ_NotTaken) {
  u->state = state::fetch;
  u->PC = 0x0080;
  clockCycles(5); // 2 inst * 2 cycles + 1
  ASSERT_EQ(u->X, 0x01);
  ASSERT_EQ(u->state, state::fetch);
  ASSERT_EQ(u->PC, 0x0084);
  ASSERT_EQ(u->S, 0x00); // Not zero
}

TEST_F(CPUunitTest, InstrBEQ_Taken) {
  u->state = state::fetch;
  u->PC = 0x0090;
  clockCycles(7); // 2 inst * 2 cycles + 1
  ASSERT_EQ(u->X, 0x00);
  ASSERT_EQ(u->state, state::fetch);
  ASSERT_EQ(u->PC, 0x0097);
  ASSERT_EQ(u->S, 0x02); // Zero
}

TEST_F(CPUunitTest, InstrBNE_Neg_Taken) {
  u->state = state::fetch;
  u->PC = 0x00C0;
  clockCycles(73); //
  ASSERT_EQ(u->X, 0x00);
  ASSERT_EQ(u->state, state::fetch);
  ASSERT_EQ(u->PC, 0x00C7);
  ASSERT_EQ(u->S, 0x02); // Zero
  ASSERT_EQ(u->IR, 0xFF);
}

TEST_F(CPUunitTest, InstrBEQ_Neg_Taken) {
  u->X = 0xAA;
  u->state = state::fetch;
  u->PC = 0x0088;
  clockCycles(9); //
  ASSERT_EQ(u->X, 0x00);
  ASSERT_EQ(u->state, state::fetch);
  ASSERT_EQ(u->PC, 0x0089);
  ASSERT_EQ(u->S, 0x02); // Zero
}


TEST_F(CPUunitTest, FirstLoop) {
  u->state = state::fetch;
  u->PC = 0x00A0;
  //u->debug = 1;
  clockCycles(118);
  ASSERT_EQ(u->X, 0x00);
  ASSERT_EQ(u->state, state::fetch);
  ASSERT_EQ(u->PC, 0x00AB);
  ASSERT_EQ(u->S, 0x02); // Zero
}

TEST_F(CPUunitTest, TestHaltInstruction) {
  u->state = state::fetch;
  u->PC = 0x00B0;
  clockCycles(10);
  ASSERT_EQ(u->PC, 0x00B0);
}



int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  VerilatedCov::write("logs/cpuunit.dat");
  return res;
}
