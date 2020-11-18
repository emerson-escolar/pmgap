#include "z2.h"

namespace Core{
Z2& Z2::operator=(int other){
  num = bool(other);
  return *this;
}
Z2& Z2::operator=(bool other){
  num = other;
  return *this;
}
    
Z2& Z2::operator+=(const Z2& other){
  num = !(num == other.num);
  return *this;
}
Z2& Z2::operator-=(const Z2& other){
  *this += other;
  return *this;
}
    
Z2& Z2::operator*=(const Z2& other){
  num = (num && other.num);
  return *this;
}
    
Z2& Z2::operator/=(const Z2& other){
  if (other.num == false){
    throw; //division by 0;
  }
  return *this;
}
    
bool Z2::operator==(const Z2& other)const {
  return (num == other.num);
}
    
bool Z2::operator!=(const Z2& other)const {
  return !operator==(other);
}
    
bool Z2::operator>(const Z2& other)const {
  return (num && !other.num);
}
bool Z2::operator<(const Z2& other)const {
  return (!num && other.num);
}
bool Z2::operator>=(const Z2& other)const {
  return !operator<(other);
}
bool Z2::operator<=(const Z2& other)const {
  return !operator>(other);
}
    
Z2::operator bool()const{
  return num;
}

Z2::operator int()const{
  return (num ? 1 : 0);
}

  
    
std::ostream& operator<<(std::ostream& os, const Z2& that){
  os << (that.num ? 1:0);
  return os;
}



}
