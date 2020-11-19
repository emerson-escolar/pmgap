#include "catch.hpp"
#include "z2.h"

TEST_CASE("Z2 construction", "[z2]"){
  Core::Z2 one(1);
  Core::Z2 zero(0); 
  Core::Z2 x;
  
  REQUIRE(x == zero);
  REQUIRE(one != zero);
  REQUIRE(Core::Z2(false) == zero);
  REQUIRE(Core::Z2(true) == one);

  SECTION("assignment") {
    x = one;
    REQUIRE(x == one);
  }
  SECTION("copy construction") {
    Core::Z2 y = one;
    REQUIRE(y == one);
  }
  
}

TEST_CASE("operations", "[z2]"){
  Core::Z2 one(1);
  Core::Z2 zero(0);
  

  SECTION("addition") {
    REQUIRE( zero + zero == zero );
    REQUIRE( one + one == zero );
    REQUIRE( one + zero == one );
    REQUIRE( zero + one == one );
  }

  SECTION("subtraction") {
    REQUIRE( zero - zero == zero );
    REQUIRE( one - one == zero );
    REQUIRE( one - zero == one );
    REQUIRE( zero - one == one );
  }
  SECTION("multiplication") {
    REQUIRE( zero * zero == zero );
    REQUIRE( one * one == one );
    REQUIRE( one * zero == zero );
    REQUIRE( zero * one == zero );
  }

  SECTION("division") {
    // CHECK_THROWS( zero / zero );
    // CHECK_THROWS( one / zero );
    REQUIRE( one / one == one );
    REQUIRE( zero / one == zero );    
  }  
}

TEST_CASE("in-place operations", "[z2]"){
  Core::Z2 one(1);
  Core::Z2 zero(0);

  Core::Z2 x = one;
  Core::Z2 y = zero;

  SECTION("addition, on 1") {
    x += zero;
    REQUIRE(x == one);
    x += one;
    REQUIRE(x == zero);
  }

  SECTION("subtraction, on 1") {
    x -= zero;
    REQUIRE(x == one);
    x -= one;
    REQUIRE(x == zero);
  }

  SECTION("addition, on 0") {
    y += zero;
    REQUIRE(y == zero);
    y += one;
    REQUIRE(y == one);
  }

  SECTION("subtraction, on 0") {
    y -= zero;
    REQUIRE(y == zero);
    y -= one;
    REQUIRE(y == one);
  }
  
}


/***
Adopted from gyoza
(https://bitbucket.org/remere/gyoza)
Original file: test_z2.cpp
Used under GPL3.
 ***/
