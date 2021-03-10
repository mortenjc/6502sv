// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for memory address multiplexer
//===----------------------------------------------------------------------===//

#include <control.h>
#include <control_common_types.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class TestCase {
public:
  std::string name;
  uint8_t state;
  uint8_t data;
  uint16_t expected_state;
  uint16_t expected_mm;
  uint16_t expected_il;
  uint16_t expected_mw;
};

using state = control_common_types::state_t;
using mm = control_common_types::mm_t;
using mw = control_common_types::mw_t;
using il = control_common_types::il_t;
std::vector<TestCase> tests {
  {"inf", state::INF, 0x00, state::EX0, mm::PC_ADDR, il::LOAD, mw::READ},
  {"ex0", state::EX0, 0x00, state::INF, mm::PC_ADDR, il::NOLOAD, mw::READ},
};

class ControlTest: public ::testing::Test {
protected:
  control * ctl;

  void SetUp( ) {
    ctl = new control;
    ctl->eval();
  }

  void TearDown( ) {
    ctl->final();
    delete ctl;
  }
};


TEST_F(ControlTest, Initial) {
  ASSERT_EQ(ctl->mm, 0);
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
