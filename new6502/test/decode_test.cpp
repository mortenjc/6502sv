// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief instruction decode
//===----------------------------------------------------------------------===//

#include <decode.h>
#include <decode_common_types.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>
#include <math.h>


struct TestCase {
  std::string name;
  std::vector<uint8_t> instr;
  uint8_t exp_opcode;
};

using opc_t = decode_common_types::opc_t;

std::vector<struct TestCase> TestCases {
  {"BRK", {0x00}, opc_t::BRK},
  {"AND", {0x21, 0x25, 0x29, 0x2D, 0x31, 0x35, 0x39, 0x3D}, opc_t::AND},
  {"ORA", {0x01, 0x05, 0x09, 0x0D, 0x11, 0x15, 0x19, 0x1D}, opc_t::ORA},
  {"EOR", {0x41, 0x45, 0x49, 0x4D, 0x51, 0x55, 0x59, 0x5D}, opc_t::EOR},
  {"ADC", {0x61, 0x65, 0x69, 0x6D, 0x71, 0x75, 0x79, 0x7D}, opc_t::ADC},
  {"STA", {0x81, 0x85, 0x89, 0x8D, 0x91, 0x95, 0x99, 0x9D}, opc_t::STA},
  {"LDA", {0xA1, 0xA5, 0xA9, 0xAD, 0xB1, 0xB5, 0xB9, 0xBD}, opc_t::LDA},
  {"CMP", {0xC1, 0xC5, 0xC9, 0xCD, 0xD1, 0xD5, 0xD9, 0xDD}, opc_t::CMP},
  {"SBC", {0xE1, 0xE5, 0xE9, 0xED, 0xF1, 0xF5, 0xF9, 0xFD}, opc_t::SBC},
};

class DecodeTest: public ::testing::Test {
protected:
  decode * dec;

  void SetUp( ) {
    dec = new decode;
  }

  void TearDown( ) {
    dec->final();
    delete dec;
  }
};



TEST_F(DecodeTest, InitialState) {
  dec->instr = 0x00;
  dec->eval();
  ASSERT_EQ(dec->opcode, opc_t::BRK);
}

TEST_F(DecodeTest, Instructions) {
  for (auto & test : TestCases) {
    printf("%s ", test.name.c_str());
    for (auto & instr : test.instr) {
      printf("0x%02x ", instr);
      dec->instr = instr;
      dec->eval();
      ASSERT_EQ(dec->opcode, test.exp_opcode);
    }
    printf("\n");
  }
}



int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  VerilatedCov::write("logs/decode.dat");
  return res;
}
