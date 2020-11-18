#include <iostream>
#include <fstream>

#include "lib/gridcomplex.h"
#include "lib/setchain.h"

int main(){
  pmgap::GridComplex<Core::Algebra::SetChain> x(4,3);
  // std::cout << x.get_num_vertices() << std::endl;

  std::ifstream ifs;
  ifs.open("gridcomplex_sample.json");
  x.read_json(ifs);

  x.naive_compute_persistence(1, std::cout);

  return 0;
}
