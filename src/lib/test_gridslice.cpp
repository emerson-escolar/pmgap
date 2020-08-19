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

TEST_CASE("invalid births and slices",
          "[gridslice]"){
  GS gs(4,3);
  CHECK_THROWS(gs.slice_to_birth(12));
  CHECK_THROWS(gs.slice_to_birth(-1));

  CHECK_THROWS(gs.birth_to_slice(BT(5,3)));
  CHECK_THROWS(gs.birth_to_slice(BT(4,4)));
}

TEST_CASE("grid slice",
          "[gridslice]"){
  GS gs(4,3);
  CHECK(gs.num_rows == 4);
  CHECK(gs.num_cols == 3);

  BT bt = gs.slice_to_birth(0);
  CHECK(bt.row() == 1);
  CHECK(bt.col() == 1);

  bt = gs.slice_to_birth(1);
  CHECK(bt.row() == 1);
  CHECK(bt.col() == 2);

  bt = gs.slice_to_birth(10);
  CHECK(bt.row() == 4);
  CHECK(bt.col() == 2);

  bt = gs.slice_to_birth(11);
  CHECK(bt.row() == 4);
  CHECK(bt.col() == 3);
}
