#include "slicedhomology.h"
#include "setchain.h"

namespace pmgap {

template<typename Chain_T>
void SlicedHomology<Chain_T>::load_cells(const std::vector<Cell_T> & cells) {
  /*
    Copies information over and over again. (boundary chains, especially)
    This can be seen to be very bad.
    But, because this code aims at (extreme) generality for
    treating quiver complexes, it is possible that
    the boundary chains at different slices may be reduced in different manners,
    and thus we need copies eventually.

    Heuristic? Delayed copying as needed?
    Can't figure out a way of doing that in a simple way.
  */
  dimensions = std::vector<int>(cells.size(), -1);
  Index i = 0;
  for (const auto & cell : cells) {
    assert(i == cell.index);
    dimensions.at(i) = cell.dimension;

    for (int slice = 0; slice < num_slices; ++slice) {
      if ( cell.birth <= gs.slice_to_birth(slice) ) {
        sliced_boundary_matrix.at(slice).push_back(cell.bdd);

        Chain_T basis_chain;
        basis_chain.set_entry(cell.index ,1);
        sliced_basis.at(slice).push_back(basis_chain);

        sliced_global_to_local.at(slice)[cell.index] =
            sliced_basis.at(slice).size() - 1;
      }
    }
    ++i;
  }
  cells_loaded = true;
  return;
}

template<typename Chain_T>
std::tuple<typename SlicedHomology<Chain_T>::Index,
           typename SlicedHomology<Chain_T>::LocalIndex>
SlicedHomology<Chain_T>::get_pivot_l_value(LocalIndex j, int slice) {
  std::vector<Chain_T>& bdd = bdd_slice(slice);
  const std::map<Index,LocalIndex>& global_local = glocal_slice(slice);
  std::vector<LocalIndex>& lookup_table = lookup_slice(slice);

  Index pivot = bdd.at(j).get_pivot();
  LocalIndex l_value = -1;
  if (pivot != -1) {
    LocalIndex local_pivot = global_local.at(pivot);
    l_value = lookup_table.at(local_pivot);
  }
  return std::tuple<typename SlicedHomology<Chain_T>::Index,
           typename SlicedHomology<Chain_T>::LocalIndex>{pivot, l_value};
}


template<typename Chain_T>
void SlicedHomology<Chain_T>::compute_homology_at_slice(int slice,
                                                       int target_dimension) {
  std::vector<Chain_T>& basis = basis_slice(slice);
  std::vector<Chain_T>& bdd = bdd_slice(slice);
  const std::map<Index,LocalIndex>& global_local = glocal_slice(slice);
  std::vector<LocalIndex>& lookup_table = lookup_slice(slice);

  int filtration_size = basis.size();
  assert(bdd.size() == filtration_size);

  lookup_table = std::vector<LocalIndex>(filtration_size, -1);

  for (LocalIndex j = 0; j < filtration_size; ++j) {
    typename Cell_T::Index original_index = basis.at(j).get_pivot();
    int cell_dimension = dimensions.at(original_index);

    Index pivot = -1; LocalIndex l_value = -1;
    std::tie(pivot, l_value) = get_pivot_l_value(j, slice);

    while( pivot != -1 && l_value != -1 ) {
      bdd.at(j) += bdd.at(l_value);
      basis.at(j) += basis.at(l_value);

      std::tie(pivot, l_value) = get_pivot_l_value(j, slice);
    }

    if (pivot != -1) {
      if (cell_dimension == target_dimension + 1) {
        sliced_boundary_image_basis.at(slice).insert(j);
      }
      LocalIndex local_pivot = global_local.at(pivot);
      lookup_table[local_pivot] = j;
      sliced_homology_basis.at(slice).erase(local_pivot);
    }

    if (pivot == -1 && cell_dimension == target_dimension) {
      sliced_homology_basis.at(slice).insert(j);
    }
  }
  sliced_homology_computed.at(slice) = true;
  return;
}

template<typename Chain_T>
Core::Z2Matrix SlicedHomology<Chain_T>::compute_induced_map(int source, int target) {
  if ( not (sliced_homology_computed.at(source) &&
            sliced_homology_computed.at(target))) {
    throw("Cannot compute induced homology map before computing homology.");
  }

  int colsize = sliced_homology_basis.at(source).size();
  int rowsize = sliced_homology_basis.at(target).size();

  Core::Z2Matrix linearmap(rowsize, colsize);
  // std::cerr << "Matrix: " << rowsize << "x" << colsize << "\n";

  int curcolnum = 0;
  std::map<LocalIndex,int> targetbasisindex_to_linearmaprow;
  int rowposition = 0;
  for (const LocalIndex & num : sliced_homology_basis.at(target) ){
    targetbasisindex_to_linearmaprow[ num ] = rowposition;
    ++rowposition;
  }

  for (LocalIndex cur_col : sliced_homology_basis.at(source)){
    Chain_T to_reduce = sliced_basis.at(source).at(cur_col);
    Index pivot = to_reduce.get_pivot();

    while( pivot != -1 ) {
      // convert to the corresponding index in target.
      // Note: Source ---> Target so that Source subset Target
      LocalIndex t_local_pivot = sliced_global_to_local.at(target).at(pivot);;

      // Two cases for t_local_pivot (tlp).
      // 1. represents a birth event.
      //    pivot zeroed out by adding the basis element (a cycle),
      //    which is guaranteed to have pivot at tlp too.
      // 2. represents a death event (is part of boundary).
      //    pivot zeroed out by adding corresponding boundary,
      //    found via lookuptable

      LocalIndex cycle_chain = sliced_homology_basis.at(target).count(t_local_pivot) ? t_local_pivot : -1;
      LocalIndex l_value = sliced_lookup_table.at(target).at(t_local_pivot);

      // Exactly one of the two numbers above is nonerror state.
      bool use_cycle = (cycle_chain != -1);
      bool use_bdd = (l_value != -1);
      assert( use_cycle || use_bdd );
      assert(!(use_cycle && use_bdd));
      // std::cerr << "reduction choice: " << use_cycle << " " << use_bdd << std::endl;

      if (use_cycle) {
        to_reduce += sliced_basis.at(target).at(cycle_chain);
        int currownum = targetbasisindex_to_linearmaprow.at(cycle_chain);
        linearmap(currownum, curcolnum) = Core::Z2(1);
      }
      if (use_bdd) {
        to_reduce += sliced_boundary_matrix.at(target).at(l_value);
      }

      pivot = to_reduce.get_pivot();

    }
    ++curcolnum;
  }
  return linearmap;
}

template struct SlicedHomology<Core::Algebra::SetChain>;
}


/***
Adopted from gyoza
(https://bitbucket.org/remere/gyoza)
Original file: slicedhomology.cpp
Used under GPL3.
 ***/
