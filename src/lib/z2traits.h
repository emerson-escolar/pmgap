#ifndef Z2TRAITS_H
#define Z2TRAITS_H

#include "z2.h"
#include <Eigen/Core>

// See https://eigen.tuxfamily.org/dox/TopicCustomizingEigen.html
// "Using Custom Scalar Types"
namespace Eigen {
template<> struct NumTraits<Core::Z2> {
  typedef Core::Z2 Real;
  typedef Core::Z2 Nested;
  typedef Core::Z2 Literal;
  enum {
    IsComplex = 0,
    IsInteger = 1,
    IsSigned = 1,
    RequireInitialization = 1,
    ReadCost = 1,
    AddCost = 3,
    MulCost = 3,    
  };
  static inline Real dummy_precision() { return Real(0); }
  static inline int digits10() { return 1; } // return internal::default_digits10_impl<T>::run(); }
  
};

}

#endif
