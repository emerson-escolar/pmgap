#include "setchain.h"

#include <algorithm>
#include <vector>

namespace Core{
namespace Algebra {

constexpr int SetChain::fail_index;

std::set<int> SetChain::get_nonzeros()const{
  return nonzeros;
}

int SetChain::get_pivot()const {
  
  return ( nonzeros.size() != 0 ? *(nonzeros.crbegin()) : SetChain::fail_index );
}



void SetChain::set_entry(int index){
  if ( index != SetChain::fail_index ) {
    nonzeros.insert(index);
  } else {

  }
}

SetChain& SetChain::operator+=(const SetChain& other){
  std::vector<int> result;
  std::set_symmetric_difference(nonzeros.begin(), nonzeros.end(),
                                other.nonzeros.begin(), other.nonzeros.end(),
                                std::back_inserter(result));
  std::set<int> result_set(result.begin(), result.end());
  std::swap(result_set, nonzeros);
  
  return *this;  
}

SetChain& SetChain::operator-=(const SetChain& other){
  return this->operator+=(other);
}

std::ostream& operator<<(std::ostream& os,
                         const SetChain& that){
  os << "{";
  for (auto const & x : that.nonzeros) {
    os << x << " ";
  }
  os << "}";
  return os;
}

bool SetChain::operator==(const SetChain& other)const {
  return this->nonzeros == other.nonzeros;
}

bool SetChain::operator!=(const SetChain& other)const {
  return !(this->operator==(other));
}


SetChain operator+(SetChain lhs, const SetChain& rhs){
  lhs += rhs;
  return lhs;
}

SetChain operator-(SetChain lhs, const SetChain& rhs){
  lhs -= rhs;
  return lhs;
}

}
}

/***
Adopted from gyoza
(https://bitbucket.org/remere/gyoza)
Original file: setchain.cpp
Used under GPL3.
 ***/
