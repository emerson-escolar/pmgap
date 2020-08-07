#include "gridcomplex.h"

#include "gyoza/setchain.h"
#include "gyoza/common_definitions.h"

#include <map>
#include <cassert>

// #include "nlohmann_json/json.hpp"
// using json = nlohmann::json;

#include <functional>
#include <boost/algorithm/string/classification.hpp>
#include <boost/algorithm/string/split.hpp>
#include <boost/algorithm/string/trim.hpp>

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


// template<typename Chain_T>
// QuiverRepn QuiverComplex<Chain_T>::naive_compute_persistence(int target_dimension){
//   if (not check_integrity()) {
//     throw std::runtime_error("Attempted to compute persistence on quivercomplex with invalid data");
//   }

//   // ASSUMES Z2 Coefficients
//   int n = quiv.get_num_vertices();
//   SlicedHomology<Chain_T> pm(n);

//   // quite bad; data is copied a lot.
//   pm.load_cells(cells, births);

//   for (int slice = 0; slice < n; ++slice) {
//     pm.compute_homology_at_slice(slice, target_dimension);
//   }

//   std::vector<int> dimv;
//   dimv.reserve(quiv.get_num_vertices());
//   for ( auto slice : pm.sliced_homology_basis ) {
//     dimv.push_back(slice.size());
//   }

//   QuiverRepn pers_mod(quiv);
//   pers_mod.set_dimension_vector(dimv);
//   for (int source = 0; source < n; ++source) {
//     std::set<int> successors = quiv.get_successors(source);
//     for (auto target : successors) {
//       pers_mod.matrix_at(source,target) = pm.compute_induced_map(source,target);
//       // std::cerr << source << "-->" << target
//       // << ":\n" << pers_mod.matrix_at(source,target) << std::endl;
//     }
//   }
//   return pers_mod;
// }




template<typename Chain_T>
void GridComplex<Chain_T>::clear(){
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
