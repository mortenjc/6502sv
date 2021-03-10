// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for cpumemory
//===----------------------------------------------------------------------===//

#include <cpumemory.h>
#include <cpumemory_common_types.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class TestCase {
public:
  std::string name;
  uint16_t addr;
  uint8_t data_in;
  uint8_t mw;
  uint8_t expected_data;
};

using mem = cpumemory_common_types::mw_t;
std::vector<TestCase> tests {
  {"read1",  0x000, 0x00, mem::READ,  0xFF},
  {"read2",  0x001, 0x00, mem::READ,  0xAA},
  {"read3",  0x002, 0x00, mem::READ,  0x12},
  {"read4",  0x003, 0x00, mem::READ,  0x13},
  {"read5",  0x3FF, 0x00, mem::READ,  0x00},
  {"write1", 0x3FF, 0xAA, mem::WRITE, 0x00},
  {"rdbck1", 0x3FF, 0x00, mem::READ,  0xAA},
};

class MEMTest: public ::testing::Test {
protected:
  cpumemory * mem;

  void SetUp( ) {
    mem = new cpumemory;
    mem->clk = 0;
    mem->addr = 0;
    mem->data_in = 0;
    mem->mw = 0;
    mem->eval();
  }

  void TearDown( ) {
    mem->final();
    delete mem;
  }
};


TEST_F(MEMTest, Initial) {
  ASSERT_EQ(mem->addr, 0);
}

TEST_F(MEMTest, Read) {
  for (auto & test : tests) {
    printf("Executing test %s\n", test.name.c_str());
    mem->addr = test.addr;
    mem->mw = test.mw;
    mem->data_in = test.data_in;
    mem->eval();

    mem->clk = 1;
    mem->eval();
    mem->clk = 0;
    mem->eval();
    ASSERT_EQ(mem->data_out, test.expected_data);
  }
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
