#include "catch.hpp"
#include "setchain.h"
#include <typeinfo>


TEST_CASE("setchain initializer list constructions", "[setchain]") {
  Core::Algebra::SetChain x = {1,2,3,4,5,6};
  Core::Algebra::SetChain y = {3,4,2,5,1,6,1,2,2};
  CHECK(x == y);  
}

  
TEST_CASE("setchain constructions", "[setchain]") {
  CHECK(-1 == Core::Algebra::SetChain::fail_index);
  
  Core::Algebra::SetChain x;
  
  Core::Algebra::SetChain y = {1,2,3};
  Core::Algebra::SetChain z = y;
  CHECK(y == z);

  x = y;
  CHECK(x == y);

}



TEST_CASE("setchain pivots", "[setchain]") {
  Core::Algebra::SetChain x;

  SECTION("case empty"){  
    CHECK(-1 == x.get_pivot());
  }

  SECTION("nonempty") {
    x.set_entry(10);
    x.set_entry(5);
    CHECK(10 == x.get_pivot());    
  } 
}

TEST_CASE("setchain nonzeros", "[setchain]") {
  Core::Algebra::SetChain x = {0,1,2};
  const std::set<int> expected{0,1,2};
  CHECK(x.get_nonzeros() == expected);
}

TEST_CASE("setchain setting entries, invariant", "[setchain]") {
  Core::Algebra::SetChain x = {1,2,3};
  const Core::Algebra::SetChain expected = x;

  SECTION("adding to already existing entries") {
    x.set_entry(2);
    CHECK(x == expected);
    
    x.set_entry(2, 1); 
    CHECK(x == expected);     
  }

  SECTION("adding with coefficient T(0)") {
    x.set_entry(4, 0);
    CHECK(x == expected);

    CHECK(bool(0) == false);
    x.set_entry(5,false);
    CHECK(x == expected);

    x.set_entry(6,0.0);
    CHECK(x == expected);
  }
}

TEST_CASE("setchain setting entries", "[setchain]") {
  Core::Algebra::SetChain x = {1,2,3};
  SECTION("single entry") {
    const Core::Algebra::SetChain expected = {1,2,3,5};
    x.set_entry(5);
    CHECK(x == expected);
  }
  
}

TEST_CASE("setchain clearing", "[setchain]") {
  Core::Algebra::SetChain x = {1,2,3};
  x.clear();
  CHECK( x == Core::Algebra::SetChain{} );
}



TEST_CASE("setchain arithmetic", "[setchain]") {
  Core::Algebra::SetChain sc1 = {0,1,2};
  Core::Algebra::SetChain zero;

  SECTION("equality") {
    CHECK(zero == zero);
    CHECK(sc1 == sc1);
    CHECK_FALSE(zero != zero);
    CHECK_FALSE(sc1 != sc1);

    CHECK(zero != sc1);
    CHECK_FALSE(zero == sc1); 
  }

  SECTION("nilpotence setchain"){
    CHECK(sc1 + sc1 == zero);
  }

  SECTION("self-addition"){
    CHECK_NOTHROW(sc1 += sc1);
    CHECK(sc1 == zero); 
  }

  SECTION("self-subtraction"){
    CHECK_NOTHROW(sc1 -= sc1);
    CHECK(sc1 == zero); 
  }

  SECTION("some additions") {
    Core::Algebra::SetChain sc2 = {1,2,3};

    const Core::Algebra::SetChain expected = {0,3};
    CHECK(sc1 + sc2 == expected);
    CHECK(sc1 - sc2 == expected);
    
    sc1 += sc2;
    CHECK(sc1 == expected); 
  }
}


/***
Adopted from gyoza
(https://bitbucket.org/remere/gyoza)
Original file: test_setchain.cpp
Used under GPL3.
 ***/
