#include <iostream>
#include <fstream>
#include <string>

#include "lib/gridcomplex.h"

#include "lib/setchain.h"

#include <tclap/CmdLine.h>

int main(int argc, char** argv) {
  try{
    TCLAP::CmdLine cmd("pmgap::cmplx2repn\nThis utility takes a grid complex as input and computes its persistence module of chosen homology dimension.\nThis program comes with ABSOLUTELY NO WARRANTY. This is free software, and you are welcome to redistribute it under certain conditions; see the LICENSE file for details.", ' ', "0.1.0");

    TCLAP::ValueArg<int> dimArg("d", "dim", "Homology dimension of persistence module to construct. Defaults to 1.", false, 1, "dimension");
    cmd.add(dimArg);

    TCLAP::UnlabeledValueArg<std::string> inputFile("filename", "Filename of the input grid complex.", true, std::string(), "filename");
    cmd.add(inputFile);

    cmd.parse(argc, argv);

    int dim = dimArg.getValue();
    pmgap::GridComplex<Core::Algebra::SetChain> x;

    std::ifstream ifs;
    ifs.open(inputFile.getValue());
    x.read_json(ifs);
    ifs.close();

    x.naive_compute_persistence(dim, std::cout);

  } catch (TCLAP::ArgException &e) {
    std::cerr << "error: " << e.error()
              << " for arg " << e.argId()
              << std::endl;
  }


  return 0;
}
