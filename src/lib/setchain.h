#ifndef SETCHAIN_H
#define SETCHAIN_H

#include <set>
#include <iostream>
#include <initializer_list>
namespace Core{
namespace Algebra{

//! A chain over the finite field of two elements, represented implictly.
/*! 

  Mathematically, this represents a vector in (GF(2)), a vector space
  over GF(2), where GF(2) is the finite field of two elements. Note
  that we do not specify explicitly the dimension of the vector space,
  nor do we explictly represent the vector space. We only work with
  vectors. Here, "chain" is taken to be a synonym for such a vector.

  SetChain stores a chain implicitly by storing only the indices of
  its nonzero entries, as a set of ints.

  \sa MapChain, Z2
 */
class SetChain {
 public:
  //! Default empty chain constructor
  SetChain()=default;

  //! Default copy constructor
  SetChain(const SetChain&) = default;
  
  //! Initializer list construction. 
  /*! Fills the positions of the nonzeros of SetChain using the given
    initializer list. 

    \warning This automatically deletes SetChain::fail_index from the
    input. 

    \todo Make this warning (SetChain(std::initializer_list<int>))
    explicit in runtime?
   */
  SetChain(std::initializer_list<int> l) : nonzeros(l) {
    if (nonzeros.erase(SetChain::fail_index)) {
      // TODO: warn about erased element?
    }
  }


  //! Gets the indices with nonzero entries.
  /*! 
    \return set of indices
  */
  std::set<int> get_nonzeros() const;

  typename std::set<int>::size_type size() const {return nonzeros.size();}  
  
  //! Gets the pivot of the chain
  /*! The pivot is defined to be the index of the largest nonzero
   element, viewing the chain as a vector. Equivalently, this is the
   largest integer in SetChain::get_nonzeros.
    
    \return the pivot, or SetChain::fail_index
  */
  int get_pivot() const;


  //! Sets entry to 1 at index, if fake_coeff is nonzero.
  /*! Primarily provided as a convenience function for code that works
    expects to explicitly have the specify the coefficient (entry) of
    the index being set in the vector.

    \note If fake_coeff is equal to the zero of type T ( == T(0) ),
    then the SetChain will not be changed.

    \note If entry at index is already nonzero, or if index is
    SetChain::fail_index, then the SetChain will not be changed!

    \param index       
    \param fake_coeff   
  */
  template<typename T>
  void set_entry(int index, T fake_coeff){  
    if ( index == SetChain::fail_index ) {
      return;
    }  
    if (fake_coeff != T(0)) {
      nonzeros.insert(index);
    }
  }
  
  //! Sets entry to 1 at index.
  /*!     
    \note If entry at index is already nonzero, or if index is
    SetChain::fail_index, then the SetChain will not be changed!

    \param index
  */
  void set_entry(int index);  


  SetChain& operator+=(const SetChain& other);
  SetChain& operator-=(const SetChain& other);

  bool operator==(const SetChain&) const;
  bool operator!=(const SetChain&) const;

  friend std::ostream& operator<<(std::ostream& os, 
                            const SetChain& that);

  //! Zeros out the SetChain.  
  void clear(){nonzeros.clear();}

  //! The int to represent a non-index.
  /*! Can be used to represent a failure state, or a nonexistence
    state. Semantically, this is useful for representing a "None"
    return value when a function fails to find an index. 

    An alternative would be to wrap the return value as
    std::optional<int> or boost::optional<int> and return a "None"
    explicitly, but I don't do this.

    \sa SetChain::get_pivot    
   */
  static constexpr int fail_index = -1;

 private:
  //! Set of indices with nonzero entries.
  std::set<int> nonzeros;  

};

SetChain operator+(SetChain, const SetChain&);
SetChain operator-(SetChain, const SetChain&);
}
}
#endif
