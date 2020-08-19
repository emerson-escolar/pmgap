#include "catch.hpp"
#include "slicedhomology.h"

#include <limits>
#include <cmath>

using GS = pmgap::GridSlice;
using BT = pmgap::GridBirthType;


TEST_CASE("invalid grid slices",
          "[gridslice]") {
  CHECK_THROWS(GS(0,0));
  CHECK_THROWS(GS(1,0));
  CHECK_THROWS(GS(0,1));

  int foo = int(std::sqrt(std::numeric_limits<int>::max()));
  CHECK_THROWS(GS(foo+1, foo+1));
  CHECK_NOTHROW(GS(foo,foo));
}
