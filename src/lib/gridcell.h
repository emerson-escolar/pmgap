#ifndef GRIDCELL_H
#define GRIDCELL_H

#include <utility>
#include "gridbirthtype.h"

namespace pmgap{

template<typename Chain_T>
struct GridCell {
  typedef int Index;
  typedef Chain_T Chain;
  typedef GridBirthType Birth_T ;

  Index index;
  int dimension;
  Birth_T birth;
  Chain_T bdd;
};

}

#endif

/***
Adopted from gyoza
(https://bitbucket.org/remere/gyoza)
Original file: quivercell.h
Used under GPL3.
 ***/
