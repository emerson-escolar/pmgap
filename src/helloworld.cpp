#include <iostream>
#include "lib/gridcomplex.h"

#include "gyoza/setchain.h"
#include "gyoza/common_definitions.h"

int main(){
  std::cout << "hello world" << std::endl;

  pmgap::GridComplex<gyoza::Algebra::SetChain> x(2,3);
  std::cout << x.get_num_vertices() << std::endl;

  x.create_cell(0,
                gyoza::Algebra::SetChain(),
                pmgap::GridBirthType(1,1));

  x.create_cell(0,
                gyoza::Algebra::SetChain(),
                pmgap::GridBirthType(1,2));
  x.create_cell(0,
                gyoza::Algebra::SetChain(),
                pmgap::GridBirthType(2,1));

  x.create_cell(1,
                {0,1},
                pmgap::GridBirthType(1,2));
  x.create_cell(1,
                {0,2},
                pmgap::GridBirthType(2,1));
  x.create_cell(1,
                {1,2},
                pmgap::GridBirthType(2,2));

  std::cout << x.check_integrity() << std::endl;
  x.print_cells(std::cout);

  x.naive_compute_persistence(1);

  return 0;
}
