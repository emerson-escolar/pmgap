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

void gs_tester(const GS & gs,
               int slice,
               BT::CoordIndex row,
               BT::CoordIndex col){
  BT bt = gs.slice_to_birth(slice);
  CHECK(bt.row() == row);
  CHECK(bt.col() == col);

  CHECK(slice == gs.birth_to_slice(bt));
}


TEST_CASE("grid slice",
          "[gridslice]"){
  GS gs(4,3);
  CHECK(gs.num_rows == 4);
  CHECK(gs.num_cols == 3);

  gs_tester(gs, 0, 1,1);
  gs_tester(gs, 1, 1,2);
  gs_tester(gs, 3, 2,1);

  gs_tester(gs, 10, 4,2);
  gs_tester(gs, 11, 4,3);
}

TEST_CASE("grid slice 2",
          "[gridslice]"){
  GS gs(5,7);
  CHECK(gs.num_rows == 5);
  CHECK(gs.num_cols == 7);

  gs_tester(gs, 0, 1,1);
  gs_tester(gs, 1, 1,2);
  gs_tester(gs, 7, 2,1);

  gs_tester(gs, 33, 5,6);
  gs_tester(gs, 34, 5,7);
}
