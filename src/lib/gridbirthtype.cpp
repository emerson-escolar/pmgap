#include "gridbirthtype.h"

namespace pmgap{

bool operator<(const GridBirthType& lhs, const GridBirthType& rhs) {
  return (lhs <= rhs) and (lhs != rhs);
}
bool operator<=(const GridBirthType& lhs, const GridBirthType& rhs) {
  return (lhs.data.first <= rhs.data.first) and
      (lhs.data.second <= rhs.data.second);
}
bool operator>(const GridBirthType& lhs, const GridBirthType& rhs) {
  return (lhs >= rhs) and (lhs != rhs);
}
bool operator>=(const GridBirthType& lhs, const GridBirthType& rhs) {
  return (lhs.data.first >= rhs.data.first) and
      (lhs.data.second >= rhs.data.second);
}

bool operator==(const GridBirthType& lhs, const GridBirthType& rhs) {
  return (lhs.data == rhs.data);
}
bool operator!=(const GridBirthType& lhs, const GridBirthType& rhs) {
  return (not (lhs == rhs));
}

}

std::ostream& operator<<(std::ostream& os, const pmgap::GridBirthType& bc){
  os << "(" << bc.row() << "," << bc.col();
  os << ")";
  return os;
}


/***
Adopted from gyoza
(https://bitbucket.org/remere/gyoza)
Original file: birthtype.cpp
Used under GPL3.
 ***/
