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
  uint8_t exp_opcode;
  std::vector<uint8_t> instr;
};

using opc_t = decode_common_types::opc_t;

std::vector<struct TestCase> TestCases {
  {"BRK", opc_t::BRK, {0x00}},
  {"JSR", opc_t::JSR, {0x20}},
  {"RTI", opc_t::RTI, {0x40}},
  {"RTS", opc_t::RTS, {0x60}},

  // aaabbb01 instructions
  {"AND", opc_t::AND, {0x21, 0x25, 0x29, 0x2D, 0x31, 0x35, 0x39, 0x3D}},
  {"ORA", opc_t::ORA, {0x01, 0x05, 0x09, 0x0D, 0x11, 0x15, 0x19, 0x1D}},
  {"EOR", opc_t::EOR, {0x41, 0x45, 0x49, 0x4D, 0x51, 0x55, 0x59, 0x5D}},
  {"ADC", opc_t::ADC, {0x61, 0x65, 0x69, 0x6D, 0x71, 0x75, 0x79, 0x7D}},
  {"STA", opc_t::STA, {0x81, 0x85,       0x8D, 0x91, 0x95, 0x99, 0x9D}},
  {"LDA", opc_t::LDA, {0xA1, 0xA5, 0xA9, 0xAD, 0xB1, 0xB5, 0xB9, 0xBD}},
  {"CMP", opc_t::CMP, {0xC1, 0xC5, 0xC9, 0xCD, 0xD1, 0xD5, 0xD9, 0xDD}},
  {"SBC", opc_t::SBC, {0xE1, 0xE5, 0xE9, 0xED, 0xF1, 0xF5, 0xF9, 0xFD}},

  // aaabbb10 instructions
  {"ASL", opc_t::ASL, {0x06, 0x0A, 0x0E, 0x16, 0x1E}},
  {"ROL", opc_t::ROL, {0x26, 0x2A, 0x2E, 0x36, 0x3E}},
  {"LSR", opc_t::LSR, {0x46, 0x4A, 0x4E, 0x56, 0x5E}},
  {"ROR", opc_t::ROR, {0x66, 0x6A, 0x6E, 0x76, 0x7E}},
  {"STX", opc_t::STX, {0x86, 0x8E, 0x96}},
  {"LDX", opc_t::LDX, {0xA2, 0xA6, 0xAE, 0xB6, 0xBE}},
  {"DEC", opc_t::DEC, {0xC6, 0xCE, 0xD6, 0xDE}},
  {"INC", opc_t::INC, {0xE6, 0xEE, 0xF6, 0xFE}},

  // aaabbb00 instructions
  {"BIT", opc_t::BIT, {0x24, 0x2C}},
  {"JMP", opc_t::JMP, {0x4C, 0x6C}},
  {"STY", opc_t::STY, {0x84, 0x8C, 0x94}},
  {"LDY", opc_t::LDY, {0xA0, 0xA4, 0xAC, 0xB4, 0xBC}},
  {"CPY", opc_t::CPY, {0xC0, 0xC4, 0xCC}},
  {"CPX", opc_t::CPX, {0xE0, 0xE4, 0xEC}},

  // rest
  {"CLC", opc_t::CLC, {0x18}},
  {"SEC", opc_t::SEC, {0x38}},
  {"CLI", opc_t::CLI, {0x58}},
  {"SEI", opc_t::SEI, {0x78}},
  {"TYA", opc_t::TYA, {0x98}},
  {"CLV", opc_t::CLV, {0xB8}},
  {"CLD", opc_t::CLD, {0xD8}},
  {"SED", opc_t::SED, {0xF8}},

  {"BPL", opc_t::BPL, {0x10}},
  {"BMI", opc_t::BMI, {0x30}},
  {"BVC", opc_t::BVC, {0x50}},
  {"BVS", opc_t::BVS, {0x70}},
  {"BCC", opc_t::BCC, {0x90}},
  {"BCS", opc_t::BCS, {0xB0}},
  {"BNE", opc_t::BNE, {0xD0}},
  {"BEQ", opc_t::BEQ, {0xF0}},

  {"PHP", opc_t::PHP, {0x08}},
  {"PLP", opc_t::PLP, {0x28}},
  {"PHA", opc_t::PHA, {0x48}},
  {"PLA", opc_t::PLA, {0x68}},
  {"DEY", opc_t::DEY, {0x88}},
  {"TAY", opc_t::TAY, {0xA8}},
  {"INY", opc_t::INY, {0xC8}},
  {"INX", opc_t::INX, {0xE8}},

  {"TXA", opc_t::TXA, {0x8A}},
  {"TXS", opc_t::TXS, {0x9A}},
  {"TAX", opc_t::TAX, {0xAA}},
  {"TSX", opc_t::TSX, {0xBA}},
  {"DEX", opc_t::DEX, {0xCA}},
  {"NOP", opc_t::NOP, {0xEA}}
};


// For addressing mode deocde
struct AddModTestCase {
  std::string name;
  uint8_t exp_mode;
  std::vector<uint8_t> instr;
};

using addmod_t = decode_common_types::addmod_t;

std::vector<struct AddModTestCase> AddModTestCases {
  //
  {"Indexed,Indirect", addmod_t::IXID, {0x01, 0x21, 0x41, 0x61, 0x81, 0xA1, 0xC1, 0xE1}},
  {"Zero Page",        addmod_t::ZP,   {0x05, 0x25, 0x45, 0x65, 0x85, 0xA5, 0xC5, 0xE5,
                                        0x06, 0x26, 0x46, 0x66, 0x86, 0xA6, 0xC6, 0xE6,
                                        0x24, 0x84, 0xA4, 0xC4, 0xE4}},
  {"Immediate",        addmod_t::IMM,  {0x09, 0x29, 0x49, 0x69, 0xA9, 0xC9, 0xE9,
                                        0xA2,
                                        0xA0, 0xC0, 0xE0}},
  {"Absolute",         addmod_t::ABS,  {0x0D, 0x2D, 0x4D, 0x6D, 0x8D, 0xAD, 0xCD, 0xED,
                                        0x0E, 0x2E, 0x4E, 0x6E, 0x8E, 0xAE, 0xCE, 0xEE,
                                        0x2C, 0x4C, 0x6C, 0x8C, 0xAC, 0xCC, 0xEC}},
  {"Indirect,Indexed", addmod_t::IDIX, {0x11, 0x31, 0x51, 0x71, 0x91, 0xB1, 0xD1, 0xF1}},
  {"Zero Page,X",      addmod_t::ZPX,  {0x15, 0x35, 0x55, 0x75, 0x95, 0xB5, 0xD5, 0xF5,
                                        0x16, 0x36, 0x56, 0x76, /*0x96, 0xB6,*/ 0xD6, 0xF6,
                                        0x94, 0xB4}},
  {"Zero Page,Y",      addmod_t::ZPY,  {
                                        0x96, 0xB6}},
  {"Absolute,Y",       addmod_t::ABSY, {0x19, 0x39, 0x59, 0x79, 0x99, 0xB9, 0xD9, 0xF9,
                                        0xBE}},
  {"Absolute,X",       addmod_t::ABSX, {0x1D, 0x3D, 0x5D, 0x7D, 0x9D, 0xBD, 0xDD, 0xFD,
                                        0x1E, 0x3E, 0x5E, 0x7E, /*0xBE */ 0xDE, 0xFE,
                                        0xBC}},
  {"Accumulator",      addmod_t::ACC,  {
                                        0x0A, 0x2A, 0x4A, 0x6A}},
  {"Relative",         addmod_t::REL,  {0x10, 0x20, 0x30, 0x50, 0x70, 0x90, 0xB0, 0xD0, 0xF0}},
  {"Implied",          addmod_t::IMP,  {0x00, 0x08, 0x18, 0x28, 0x38, 0x40, 0x48, 0x58, 0x60,
                                        0x68, 0x78, 0x88, 0x8A, 0x98, 0x9A, 0xA8, 0xAA, 0xB8,
                                        0xBA, 0xC8, 0xCA, 0xD8, 0xE8, 0xEA, 0xF8}},
};

//
// Test harness
//

uint8_t OpcodeInstr[256];
uint8_t AddModInstr[256];

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

//
// Test cases
//

TEST_F(DecodeTest, InitialState) {
  dec->eval();
  ASSERT_EQ(dec->opcode, opc_t::BRK);
}

TEST_F(DecodeTest, Instructions) {
  memset(OpcodeInstr, 0, sizeof(OpcodeInstr));
  uint8_t InstCount{0};

  for (auto & test : TestCases) {
    printf("%s ", test.name.c_str());
    for (auto & instr : test.instr) {
      ASSERT_EQ(OpcodeInstr[instr], 0);
      OpcodeInstr[instr]++;
      printf("0x%02x ", instr);
      dec->instr = instr;
      dec->eval();
      ASSERT_EQ(dec->opcode, test.exp_opcode);
      InstCount++;
    }
    printf("\n");
  }
  printf("Tested %d instructions\n", InstCount);
}


TEST_F(DecodeTest, BRKAddMod) {
  dec->instr = 0x01;
  dec->eval();
  ASSERT_EQ(dec->mode, addmod_t::IXID);
}

TEST_F(DecodeTest, InstAddMod) {
  memset(AddModInstr, 0, sizeof(AddModInstr));
  uint8_t InstCount{0};

  for (auto & test : AddModTestCases) {
    printf("%s ", test.name.c_str());
    for (auto & instr : test.instr) {
      ASSERT_EQ(AddModInstr[instr], 0);
      AddModInstr[instr]++;
      printf("0x%02x ", instr);
      dec->instr = instr;
      dec->eval();
      ASSERT_EQ(dec->mode, test.exp_mode);
      InstCount++;
    }
    printf("\n");
  }
  printf("Tested %d instructions\n", InstCount);
}

TEST_F(DecodeTest, CompareTests) {
  for (int i = 0; i < 256; i++) {
    //ASSERT_EQ(OpcodeInstr[i], 1);
    //printf("%d, ", i);
    ASSERT_EQ(OpcodeInstr[i], AddModInstr[i]);
  }
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  VerilatedCov::write("logs/decode.dat");
  return res;
}
