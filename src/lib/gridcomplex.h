#ifndef GRIDCOMPLEX_H
#define GRIDCOMPLEX_H

#include <vector>
#include <set>
#include <iostream>

#include "gridcell.h"

namespace pmgap {

template<typename Chain_T>
class GridComplex;

template<typename Chain_T>
class GridComplex {
 public:
  typedef GridCell<Chain_T> Cell_T;
  typedef typename Cell_T::Birth_T Birth_T;
  typedef typename std::vector<Cell_T>::size_type CellIndex;


  GridComplex(int r=0, int c=0): num_rows(r), num_cols(c){};

  int get_num_vertices()const{
    return num_rows * num_cols;
  }

  CellIndex size()const{
    return cells.size();
  }


  bool check_integrity() const;

  void print_cells(std::ostream& os)const;

  // void read_json(std::istream& input);
  // void read_txt(std::istream& input);

  // QuiverRepn naive_compute_persistence(int target_dimension);

  void clear();

  CellIndex create_cell(int dim,
                        const Chain_T& bdd,
                        const Birth_T& birth);


 private:
  int num_rows;
  int num_cols;

  std::vector<Cell_T> cells;
};

}
#endif


/***
Adopted from gyoza
(https://bitbucket.org/remere/gyoza)
Original file: quivercomplex.h
Used under GPL3.
 ***/
