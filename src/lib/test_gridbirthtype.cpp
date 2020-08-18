#include "catch.hpp"
#include "gridbirthtype.h"

using BT = pmgap::GridBirthType;

TEST_CASE("invalid birth types",
          "[gridbirthtype]") {
  CHECK_THROWS(BT(0,0));
  CHECK_THROWS(BT(1,0));
  CHECK_THROWS(BT(0,1));
}


TEST_CASE("Birth types",
          "[gridbirthtype]") {
  CHECK(BT(1,1) <= BT(2,3));
  CHECK(BT(2,3) <= BT(2,3));

  CHECK(BT(2,3) >= BT(1,1));
  CHECK(BT(2,3) >= BT(2,3));


  CHECK(BT(2,3) < BT(2,4));
  CHECK(BT(2,3) < BT(3,3));
  CHECK(BT(2,4) > BT(2,3));
  CHECK(BT(3,3) > BT(2,3));

}
