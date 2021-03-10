// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for ALU
//===----------------------------------------------------------------------===//

#include <alu.h>
#include <alu_common_types.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class TestCase {
public:
  std::string name;
  uint8_t func;
  uint8_t a_in;
  uint8_t b_in;
  uint8_t c_in;

  uint8_t exp_out;
  uint8_t exp_c_out;
};

/// \todo check ADD + SUB operations with carry
using func = alu_common_types::alu_t;
std::vector<TestCase> tests {
  {"inc",        func::AINC, 0xaa, 0xbb, 0, 0xab, 0},
  {"inc carry",  func::AINC, 0xff, 0xee, 0, 0x00, 0},
  {"inc carry2", func::AINC, 0xff, 0xee, 1, 0x00, 1},
  {"add",        func::AADD, 0x10, 0x20, 0, 0x30, 0},
  {"add c1",     func::AADD, 0xfe, 0x01, 0, 0xff, 0},
  {"add c2",     func::AADD, 0xfe, 0x01, 1, 0x00, 1},
  {"sub",        func::ASUB, 0x20, 0x10, 0, 0x10, 0},
  {"sub c1",     func::ASUB, 0x00, 0x01, 0, 0xff, 1},
  {"sub c2",     func::ASUB, 0x00, 0x01, 1, 0xfe, 1},

  {"and1",       func::AAND, 0xFF, 0xAA, 0, 0xAA, 0},
  {"and2",       func::AAND, 0xAA, 0xFF, 0, 0xAA, 0},
  {"and3",       func::AAND, 0xFF, 0x00, 0, 0x00, 0},
  {"and4",       func::AAND, 0xFF, 0xFF, 0, 0xFF, 0},

  {"and1c",      func::AAND, 0xFF, 0xAA, 1, 0xAA, 1},
  {"and2c",      func::AAND, 0xAA, 0xFF, 1, 0xAA, 1},
  {"and3c",      func::AAND, 0xFF, 0x00, 1, 0x00, 1},
  {"and4c",      func::AAND, 0xFF, 0xFF, 1, 0xFF, 1},

  {"ora1",       func::AORA, 0xAA, 0x55, 0, 0xFF, 0},
  {"ora2",       func::AORA, 0x55, 0xAA, 0, 0xFF, 0},
  {"ora3",       func::AORA, 0x00, 0xFF, 0, 0xFF, 0},
  {"ora4",       func::AORA, 0x00, 0x00, 0, 0x00, 0},

  {"ora1c",      func::AORA, 0xAA, 0x55, 1, 0xFF, 1},
  {"ora2c",      func::AORA, 0x55, 0xAA, 1, 0xFF, 1},
  {"ora3c",      func::AORA, 0x00, 0xFF, 1, 0xFF, 1},
  {"ora4c",      func::AORA, 0x00, 0x00, 1, 0x00, 1},

  {"eor1",       func::AEOR, 0x00, 0x00, 0, 0x00, 0},
  {"eor2",       func::AEOR, 0x00, 0xFF, 0, 0xFF, 0},
  {"eor3",       func::AEOR, 0xFF, 0x00, 0, 0xFF, 0},
  {"eor4",       func::AEOR, 0xFF, 0xFF, 0, 0x00, 0},

  {"eor1c",      func::AEOR, 0x00, 0x00, 1, 0x00, 1},
  {"eor2c",      func::AEOR, 0x00, 0xFF, 1, 0xFF, 1},
  {"eor3c",      func::AEOR, 0xFF, 0x00, 1, 0xFF, 1},
  {"eor4c",      func::AEOR, 0xFF, 0xFF, 1, 0x00, 1},
};

class ALUTest: public ::testing::Test {
protected:
  alu * alui;

  void SetUp( ) {
    alui = new alu;
    alui->a_in = 0;
    alui->b_in = 0;
    alui->c_in = 0;
    alui->eval();
  }

  void TearDown( ) {
    alui->final();
    delete alui;
  }
};


TEST_F(ALUTest, Initial) {
  ASSERT_EQ(alui->out, 0);
  ASSERT_EQ(alui->c_out, 0);
}

TEST_F(ALUTest, Functions) {
  for (auto & test : tests) {
    printf("Executing test %s\n", test.name.c_str());
    alui->func = test.func;
    alui->a_in = test.a_in;
    alui->b_in = test.b_in;
    alui->c_in = test.c_in;
    alui->eval();

    ASSERT_EQ(alui->out, test.exp_out);
    ASSERT_EQ(alui->c_out, test.exp_c_out);
  }
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
