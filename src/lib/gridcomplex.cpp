#include "gridcomplex.h"

#include "gyoza/setchain.h"
#include "gyoza/common_definitions.h"

#include <map>
#include <cassert>
#include <string>
#include <stdexcept>

#include "nlohmann/json.hpp"
using json = nlohmann::json;

#include <functional>
#include <boost/algorithm/string/classification.hpp>
#include <boost/algorithm/string/split.hpp>
#include <boost/algorithm/string/trim.hpp>

#include "slicedhomology.h"

namespace pmgap{
template<typename Chain_T>
bool GridComplex<Chain_T>::check_integrity() const {
  // check that the data represents an
  // actual (fits-the-definition) quiver complex.

  int num = 0;
  for (const Cell_T & cell : cells) {
    if (not ((1 <= cell.birth.row() <= num_rows) and
             (1 <= cell.birth.col() <= num_cols))){
      std::cerr << "Invalid birth" << std::endl;
      return false;
    }

    Chain_T bdd_of_bdd;
    for (auto index : cell.bdd.get_nonzeros()){
      if (not (cell.birth >= cells.at(index).birth)){
        std::cerr << "Births of face-coface pair not consistent" << std::endl;
        std::cerr << "face: " << cell.birth << " vs "
                  << "bdd: " << cells.at(index).birth
                  << std::endl;
        return false;
      }
      // Z2 coefficients
      bdd_of_bdd += cells.at(index).bdd;
    }
    if (bdd_of_bdd.get_nonzeros().size() != 0){
      std::cerr << "invalid bdd of bdd! cell " << num << std::endl;
      return false;
    }
    ++num;
  }
  return true;
}


template<typename Chain_T>
void GridComplex<Chain_T>::print_cells(std::ostream& os)const {
  for (const Cell_T & cell : cells) {
    os << "CELL " << cell.index
       << ", dim: " << cell.dimension
       << ", birth: " << cell.birth
       << ", bdd: " << cell.bdd << "\n";
  }
}



int read_number(const json& ij,
                const std::string& search_string,
                const std::string& what){
  json::const_iterator it = ij.find(search_string);
  if (it != ij.cend() and
      it->is_number()){
    return it->get<int>();
  } else {
    throw std::runtime_error(std::string("Input json does not give ") + search_string + what);
    return -1;
  }
}

void check_json_cell(const json& jcell){
  if (not jcell.is_object() or
      jcell.find("d") == jcell.cend() or
      not jcell["d"].is_number() or
      jcell.find("b") == jcell.cend() or
      not jcell["b"].is_array() or
      jcell.find("t") == jcell.cend() or
      not jcell["t"].is_array() or
      not (jcell["t"].size() == 2)
      ) {
    throw std::runtime_error(std::string("Invalid cell data in input json file: ") + jcell.dump() + ". EXPECTED: a json object with keys \"d\" (dimension, number), \"b\" (boundary, array of numbers), and \"t\" (birth time, size-2 array of numbers).");
  }
  return;
}

template<typename Chain_T>
void GridComplex<Chain_T>::read_json(std::istream& is){
  json input_json;
  is >> input_json;
  this->clear_cells();

  num_rows = read_number(input_json, "rows", " of underlying grid.");
  num_cols = read_number(input_json, "cols", " of underlying grid.");

  json::const_iterator cells_it = input_json.find("cells");
  if (cells_it != input_json.end() and
      cells_it->is_array()){
    int cells_processed = 0;
    for (auto const & jcell : *cells_it){
      check_json_cell(jcell);

      int celldim = read_number(jcell, "d", " (dimension) of cell");
      Chain_T cellbdd;
      for (auto bddx : jcell["b"]) {
        cellbdd.set_entry(bddx, 1);
      }
      GridBirthType cellbirth(jcell["t"][0].get<int>(),
                              jcell["t"][1].get<int>());

      CellIndex indx = this->create_cell(celldim,
                                         cellbdd,
                                         cellbirth);
      assert((int)indx == cells_processed);
      ++cells_processed;
    }
  } else {
    throw std::runtime_error(std::string("Unable to read cells from input json file."));
    return;
  }
}




template<typename Chain_T>
void GridComplex<Chain_T>::naive_compute_persistence(int target_dimension, std::ostream& os){
  if (not check_integrity()) {
    throw std::runtime_error("Attempted to compute persistence on gridcomplex with invalid data");
  }

  SlicedHomology<Chain_T> pm(GridSlice(num_rows, num_cols));

  // quite bad; data is copied a lot.
  pm.load_cells(cells);

  os << "{\"rows\":" << num_rows << "," << std::endl;
  os << "\"cols\":" << num_cols << "," << std::endl;
  os << "\"field\":2" << "," << std::endl;
  os << "\"dimensions\":{" << std::endl;

  for (int slice = 0; slice < pm.get_num_slices(); ++slice) {
    pm.compute_homology_at_slice(slice, target_dimension);

    GridBirthType bt = pm.gs.slice_to_birth(slice);
    os << "\"" << bt.row() << "_" << bt.col() << "\":"
       << pm.sliced_homology_basis.at(slice).size();
    if (slice != pm.get_num_slices() - 1) {
      os << ",";
    }
    os << std::endl;
  }
  os << "}," << std::endl;

  os << "\"matrices\":{" << std::endl;
  struct {
    Eigen::IOFormat fmt = Eigen::IOFormat(Eigen::StreamPrecision, 0, ", ", ",", "[", "]", "[", "]");
    void operator()(SlicedHomology<Chain_T>& pm,
                    const GridBirthType& source,
                    const GridBirthType& target,
                    std::ostream& os) {
      int source_slice = pm.gs.birth_to_slice(source);
      int target_slice = pm.gs.birth_to_slice(target);
      gyoza::Z2Matrix mat = pm.compute_induced_map(source_slice,target_slice);
      if (0 == mat.rows() or 0 == mat.cols()){
        os << "\""
           << source.row() << "_" << source.col() << "_"
           << target.row() << "_" << target.col()
           << "\":"
           << "0";
        return;
      } else {
        os << "\""
           << source.row() << "_" << source.col() << "_"
           << target.row() << "_" << target.col()
           << "\":"
           << mat.format(fmt);
      }
    }
  } _st_map_compute;

  for (int row = 1; row <= num_rows; ++row){
    for (int col = 1; col <= num_cols; ++col){
      GridBirthType source(row, col);
      if (row + 1 <= num_rows) {
        GridBirthType target(row+1, col);
        _st_map_compute(pm, source, target, os);
        os << "," << std::endl;
      }
      if (col + 1 <= num_cols) {
        GridBirthType target(row, col+1);
        _st_map_compute(pm, source, target, os);
        if (not (row == num_rows and col + 1 == num_cols)){
          os << "," << std::endl;
        }
      }
    }
  }
  os << "}" << std::endl;
  os << "}";
}


template<typename Chain_T>
void GridComplex<Chain_T>::clear_cells(){
  cells.clear();
}

template<typename Chain_T>
typename GridComplex<Chain_T>::CellIndex
GridComplex<Chain_T>::create_cell(int dim, const Chain_T& bdd,
                                  const Birth_T& birth){
  CellIndex indx = cells.size();

  Cell_T a_cell;
  // TODO fix (remove) the necessity of this conversion
  // CellIndex probably resolves to unsigned int(?) for size_type.
  // for small enough input this should not be a problem.
  a_cell.index = (typename Cell_T::Index)(indx);
  a_cell.dimension = dim;
  a_cell.birth = birth;
  a_cell.bdd = bdd;

  cells.push_back(a_cell);
  return indx;
}


template struct GridCell<gyoza::Algebra::SetChain>;  //

template class GridComplex<gyoza::Algebra::SetChain>;
// template std::istream& operator>>(std::istream& input, QuiverComplex<gyoza::Algebra::SetChain> & qc);


// template ladderpersistence::RepnCLfb QuiverComplex<gyoza::Algebra::SetChain>::naive_compute_persistence_as_repn<ladderpersistence::RepnCLfb>(int);

}


/***
Adopted from gyoza
(https://bitbucket.org/remere/gyoza)
Original file: quivercomplex.cpp
Used under GPL3.
 ***/
