#include <iostream>
#include <fstream>
#include "lib/gridcomplex.h"

#include "gyoza/setchain.h"
#include "gyoza/common_definitions.h"

int main(){
  pmgap::GridComplex<gyoza::Algebra::SetChain> x(4,3);
  // std::cout << x.get_num_vertices() << std::endl;

  std::ifstream ifs;
  ifs.open("gridcomplex_sample.json");
  x.read_json(ifs);

  x.naive_compute_persistence(1, std::cout);

  return 0;
}


// x.clear_cells();


  // x.create_cell(0,
  //               gyoza::Algebra::SetChain(),
  //               pmgap::GridBirthType(1,1));

  // x.create_cell(0,
  //               gyoza::Algebra::SetChain(),
  //               pmgap::GridBirthType(1,2));
  // x.create_cell(0,
  //               gyoza::Algebra::SetChain(),
  //               pmgap::GridBirthType(2,1));

  // x.create_cell(1,
  //               {0,1},
  //               pmgap::GridBirthType(1,2));
  // x.create_cell(1,
  //               {0,2},
  //               pmgap::GridBirthType(2,1));
  // x.create_cell(1,
  //               {1,2},
  //               pmgap::GridBirthType(2,2));


  // x.create_cell(0,
  //               gyoza::Algebra::SetChain(),
  //               pmgap::GridBirthType(1,1));

  // x.create_cell(0,
  //               gyoza::Algebra::SetChain(),
  //               pmgap::GridBirthType(1,2));
  // x.create_cell(0,
  //               gyoza::Algebra::SetChain(),
  //               pmgap::GridBirthType(2,1));

  // x.create_cell(1,
  //               {6,7},
  //               pmgap::GridBirthType(1,2));
  // x.create_cell(1,
  //               {6,8},
  //               pmgap::GridBirthType(2,1));
  // x.create_cell(1,
  //               {7,8},
  //               pmgap::GridBirthType(2,2));

  // std::cout << x.check_integrity() << std::endl;
  // x.print_cells(std::cout);
