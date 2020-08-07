#ifndef GRIDBIRTHTYPE_H
#define GRIDBIRTHTYPE_H

#include <iostream>
#include <utility>
#include <assert.h>
// #include <initializer_list>

namespace pmgap {
class GridBirthType {
 public:
  typedef unsigned int CoordIndex;
  GridBirthType() = default;
  GridBirthType(CoordIndex row,
                CoordIndex col) : data(row,col) {
    assert(row > 0 and col > 0);
  };

  CoordIndex row() const {
    return data.first;
  }
  CoordIndex col() const {
    return data.second;
  }

  std::pair<CoordIndex, CoordIndex> data;

};


bool operator<(const GridBirthType& lhs, const GridBirthType& rhs);
bool operator<=(const GridBirthType& lhs, const GridBirthType& rhs);
bool operator>(const GridBirthType& lhs, const GridBirthType& rhs);
bool operator>=(const GridBirthType& lhs, const GridBirthType& rhs);
bool operator==(const GridBirthType& lhs, const GridBirthType& rhs);
bool operator!=(const GridBirthType& lhs, const GridBirthType& rhs);

}

std::ostream& operator<<(std::ostream& os,
                         const pmgap::GridBirthType& bc);

#endif


/***
Adopted from gyoza
(https://bitbucket.org/remere/gyoza)
Original file: birthtype.h
Used under GPL3.
 ***/
