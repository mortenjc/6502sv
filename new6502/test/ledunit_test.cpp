// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief instruction decode
//===----------------------------------------------------------------------===//

#include <ledunit.h>
#include <ledunit_common_types.h>
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

class LedunitTest: public ::testing::Test {
protected:
  ledunit * u;

  void SetUp( ) {
    u = new ledunit;
  }

  void TearDown( ) {
    u->final();
    delete u;
  }
};

//
// Test cases
//

TEST_F(LedunitTest, Init) {
  u->eval();
  ASSERT_EQ(1, 1);
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  VerilatedCov::write("logs/ledunit.dat");
  return res;
}
