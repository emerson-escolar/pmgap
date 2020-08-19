#ifndef SLICEDHOMOLOGY_H
#define SLICEDHOMOLOGY_H

#include "gyoza/setchain.h"
#include "gyoza/common_definitions.h"

#include "gridbirthtype.h"
#include "gridcell.h"
#include <assert.h>

#include <tuple>
#include <map>

#include <limits>

namespace pmgap{

class GridSlice {
 public:
  int num_rows;
  int num_cols;
  int n;

  GridSlice()=delete;
  GridSlice(int r, int c): num_rows(r), num_cols(c){
    if (not (r > 0 and c > 0)){
      throw std::runtime_error(std::string("Invalid GridSlice: ") + std::to_string(r) + "," + std::to_string(c));
    }
    n = r*c;
    if (r > std::numeric_limits<int>::max() / c){
      throw std::runtime_error(std::string("GridSlice too large (overflowed!): ") + std::to_string(r) + "," + std::to_string(c));
    }
  };

  int birth_to_slice(const GridBirthType& bt) const{
    return (bt.row()-1) * num_cols + bt.col() - 1;
  };
  GridBirthType slice_to_birth(int slice) const{
    assert(0<=slice < n);
    int col = (slice % num_cols) + 1;
    int row = int(slice / num_cols) + 1;
    return GridBirthType(row,col);
  };
};



template<typename Chain_T>
struct SlicedHomology {
 public:
  using LocalIndex = int;

  typedef GridCell<Chain_T> Cell_T;
  typedef typename Cell_T::Index Index;

  GridSlice gs;
  int num_slices;
  int get_num_slices()const{return num_slices;};

  //**initial data**
  std::vector<std::vector<Chain_T>> sliced_boundary_matrix;
  std::vector<std::vector<Chain_T>> sliced_basis;
  std::vector<std::map<Index,LocalIndex>> sliced_global_to_local;
  std::vector<int> dimensions;
  bool cells_loaded;
  //****************

  //**homology data**
  std::vector<std::set<LocalIndex>> sliced_homology_basis;
  std::vector<std::set<LocalIndex>> sliced_boundary_image_basis;
  std::vector<std::vector<LocalIndex>> sliced_lookup_table;
  std::vector<bool> sliced_homology_computed;
  //*****************

  // "convenience" functions that return references to data at a slice.
  std::vector<Chain_T>& bdd_slice(int n){return sliced_boundary_matrix.at(n);}
  std::vector<Chain_T>& basis_slice(int n){return sliced_basis.at(n);}
  std::map<Index,LocalIndex>& glocal_slice(int n){return sliced_global_to_local.at(n);}
  std::vector<LocalIndex>& lookup_slice(int n){return sliced_lookup_table.at(n);}

  SlicedHomology()=delete;
  SlicedHomology(const GridSlice& gs) : num_slices(gs.n), sliced_boundary_matrix(gs.n), sliced_basis(gs.n), sliced_global_to_local(gs.n), sliced_homology_basis(gs.n), sliced_boundary_image_basis(gs.n), sliced_lookup_table(gs.n), sliced_homology_computed(gs.n, false), gs(gs) {};

  void load_cells(const std::vector<Cell_T> & cells);
  void compute_homology_at_slice(int slice, int target_dimension);
  gyoza::Z2Matrix compute_induced_map(int source, int target);


 private:
  std::tuple<typename SlicedHomology<Chain_T>::Index,
             typename SlicedHomology<Chain_T>::LocalIndex>
  get_pivot_l_value(LocalIndex j, int slice);
};


}

#endif


/***
Adopted from gyoza
(https://bitbucket.org/remere/gyoza)
Original file: slicedhomology.h
Used under GPL3.
 ***/
