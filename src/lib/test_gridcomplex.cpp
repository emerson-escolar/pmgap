#include "catch.hpp"

#include "setchain.h"
#include "gridcomplex.h"

#include <sstream>

TEST_CASE("Grid Complex json Reader",
          "[gridcomplex]") {
  pmgap::GridComplex<Core::Algebra::SetChain> gc;

  std::stringstream ss;
  ss << "{\"rows\":2, \"cols\":3, \"cells\": [{\"d\":0,\"b\":[], \"t\":[1,1]}, {\"d\":0,\"b\":[], \"t\":[1,2]}, {\"d\":1,\"b\":[0,1], \"t\":[2,2]}]}";

  gc.read_json(ss);
  CHECK(gc.get_num_vertices() == 6);
  CHECK(gc.size() == 3);
  CHECK(gc.check_integrity());
}

TEST_CASE("Grid Complex - bad boundary",
          "[gridcomplex]") {
  pmgap::GridComplex<Core::Algebra::SetChain> gc;

  std::stringstream ss;
  ss << "{\"rows\":2, \"cols\":3, \"cells\": [{\"d\":0,\"b\":[], \"t\":[1,1]}, {\"d\":0,\"b\":[], \"t\":[1,2]}, {\"d\":1,\"b\":[0,1], \"t\":[1,1]}]}";

  gc.read_json(ss);
  CHECK_FALSE(gc.check_integrity());
}


TEST_CASE("Grid Complex - create cell",
          "[gridcomplex]") {

  Core::Algebra::SetChain emptybdd;
  pmgap::GridBirthType bt(1,1);

  pmgap::GridComplex<Core::Algebra::SetChain> gc(2,2);

  // Three vertices
  CHECK(0 == gc.create_cell(0, emptybdd, bt));
  CHECK(gc.size() == 1);

  CHECK(1 == gc.create_cell(0, emptybdd, bt));
  CHECK(gc.size() == 2);

  CHECK(2 == gc.create_cell(0, emptybdd, bt));
  CHECK(gc.size() == 3);
  CHECK(gc.check_integrity());

  // two edges
  CHECK(3 == gc.create_cell(1, {0,1}, bt));
  CHECK(4 == gc.create_cell(1, {2,2}, bt));
  CHECK(gc.check_integrity());

  // not assumed to be simplicial!
  CHECK(5 == gc.create_cell(2, emptybdd, bt));
  CHECK(gc.size() == 6);
  CHECK(gc.check_integrity());

  CHECK_NOTHROW(gc.naive_compute_persistence(2, std::cout));

  SECTION("invalid birth") {
    CHECK(6 == gc.create_cell(0, emptybdd, pmgap::GridBirthType(3,3)));
    CHECK_FALSE(gc.check_integrity());
  }

  SECTION("non zero bdd of bdd"){
    CHECK(6 == gc.create_cell(2, {3,4}, bt));
    CHECK_FALSE(gc.check_integrity());
  }
}
