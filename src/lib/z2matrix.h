#ifndef Z2MATRIX_H
#define Z2MATRIX_H


#include "z2.h"
#include "z2traits.h"
#include <boost/optional.hpp>
#include <Eigen/Core>
#include <ostream>
#include <vector>

namespace Core {

typedef Eigen::Matrix<Core::Z2, Eigen::Dynamic, Eigen::Dynamic> Z2Matrix;
typedef Z2Matrix::Index Index;
typedef Z2Matrix::Scalar Scalar;

void z2matrix_ascii_write(std::ostream& out, const Z2Matrix& mat);

boost::optional<Z2Matrix> z2matrix_ascii_read(std::istream& in);
Z2Matrix z2matrix_from_vector(const std::vector<Core::Z2>& in, Index rows, Index cols);

}



#endif
