#include "catch.hpp"

#include "z2matrix.h"

#include <boost/optional/optional_io.hpp>

TEST_CASE("Z2 matrix write-read", "[z2matrix]"){
  Core::Z2Matrix expected(2,3);
  expected << 0,1,1,0,0,1;

  std::vector<Core::Z2> as_vec = {0,1,1,0,0,1};
  std::string as_string = "2 3\n011\n001";

  SECTION("from vector"){
    Core::Z2Matrix red = Core::z2matrix_from_vector(as_vec, 2, 3);
    REQUIRE(red == expected);

    red(0,0) = 1;
    REQUIRE_FALSE(red == expected);
    Core::Z2Matrix red_2 = Core::z2matrix_from_vector(as_vec, 2, 3);
    REQUIRE_FALSE(red == red_2);
  }

  SECTION("from string"){
    std::stringstream ss(as_string);
    auto mat_read = Core::z2matrix_ascii_read(ss);
    REQUIRE(mat_read != boost::none);
    REQUIRE(expected == *mat_read);
  }

  SECTION("insufficient data: rows"){
    // declare three rows instead?! data now insufficient:
    as_string[0] = '3';
    std::stringstream ss(as_string);
    auto mat_read = Core::z2matrix_ascii_read(ss);
    REQUIRE(mat_read == boost::none);
  }

  SECTION("mis-sized data: cols"){
    as_string.append("1");
    std::stringstream ss(as_string);
    auto mat_read = Core::z2matrix_ascii_read(ss);
    REQUIRE(mat_read == boost::none);
  }

}


/***
Adopted from gyoza
(https://bitbucket.org/remere/gyoza)
Original file: test_z2matrix.cpp
Used under GPL3.
 ***/
