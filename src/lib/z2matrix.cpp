#include "z2matrix.h"
#include <string>
namespace Core {

void z2matrix_ascii_write(std::ostream& out, const Z2Matrix& mat){
  out << mat.rows() << " " << mat.cols() << "\n";
  Eigen::IOFormat spaceless(Eigen::StreamPrecision, 0, "");
  out << mat.format(spaceless);
}

boost::optional<Z2Matrix> z2matrix_ascii_read(std::istream& in){
  std::string line;
  std::getline(in, line);
  std::stringstream ss(line);

  std::string rows_w, cols_w;
  ss >> rows_w >> cols_w;
  Index rows = std::stoi(rows_w);
  Index cols = std::stoi(cols_w);

  std::vector<Core::Z2> data;
  for (int cur_row = 0; cur_row < rows; cur_row++) {
    if (false == bool(std::getline(in, line)) or line.size() != cols) {
      return boost::none;
    }
    for (char c : line) {
      int ic = c - '0';
      data.emplace_back(ic);
    }
  }
  return z2matrix_from_vector(data, rows, cols);
}


Z2Matrix z2matrix_from_vector(const std::vector<Core::Z2>& in, Index rows, Index cols){
  Z2Matrix ans = Eigen::Map<const Eigen::Matrix<Core::Z2, Eigen::Dynamic, Eigen::Dynamic, Eigen::RowMajor>>(&in[0],rows,cols);
  return ans;
}

}
