#ifndef Z2_H
#define Z2_H

#include <iostream>

namespace Core{
	// Z2 is the number class of integers modulo 2.
	// Internally, we represent it as a bool.
	// Of course, implementations involving
	// bit-representations for vectors and matrices
	// are more efficient, but for completeness'
	// sake we provide this class. (Conceptually, a
	// mod2 integer can exist outside of matrices and vectors.)
	class Z2{
	public:
		Z2(bool x = false): num(x){;};
		Z2(int x): num(x){;};
		
		Z2(const Z2&) = default;
		Z2(Z2&&) = default;
		Z2& operator=(const Z2&) = default;
		Z2& operator=(Z2&&) = default;
		
		Z2& operator=(int other);
		Z2& operator=(bool other);
		
		// template <typename T>
		// Z2(T) = delete;
		// template <typename T>
		// Z2& operator=(T) = delete;
		
		Z2& operator+=(const Z2& other);
		Z2& operator-=(const Z2& other);
		Z2& operator*=(const Z2& other);
		Z2& operator/=(const Z2& other);
    
		bool operator==(const Z2& other)const;
		bool operator!=(const Z2& other)const;
    
		bool operator>(const Z2& other)const;
		bool operator<(const Z2& other)const;
		bool operator>=(const Z2& other)const;
		bool operator<=(const Z2& other)const;
    
		explicit operator bool()const ;
    explicit operator int() const;
    
		friend std::ostream& operator<<(std::ostream& os, const Z2& that);
    
		bool num;
	};



	inline Z2 operator%(const Z2& lhs, const Z2& rhs){
    (void)lhs;
		if (rhs.num == false){
			throw; //division by 0;
		}
		return Z2(0);
	}

	inline Z2 operator+(Z2 lhs, const Z2& rhs){
		lhs += rhs;
		return lhs;
	}

	inline Z2 operator-(Z2 lhs, const Z2& rhs){
		lhs -= rhs;
		return lhs;
	}

	inline Z2 operator-(Z2 rhs){
		return rhs;
	}

	inline Z2 operator*(Z2 lhs, const Z2& rhs){
		lhs *= rhs;
		return lhs;
	}

	inline Z2 operator/(Z2 lhs, const Z2& rhs){
		lhs /= rhs;
		return lhs;
	}

	inline Z2 abs(Z2 rhs){
		return rhs;
	}

}

#endif


/***
Adopted from gyoza
(https://bitbucket.org/remere/gyoza)
Original file: z2.h
Used under GPL3.
 ***/
