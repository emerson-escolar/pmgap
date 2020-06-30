#! @Chapter Underlying settings

#! @Section Commutative grids

#! @Arguments field, num_rows, num_columns
#! @Returns a commutative grid path algebra
DeclareGlobalFunction("CommGridPathAlgebra");

#!
DeclareProperty("IsCommGridPathAlgebra", IsPathAlgebra);

#! @Description
#! gets the number of rows in the underlying commutative grid.
DeclareAttribute("NumCommGridRows", IsCommGridPathAlgebra);

#! @Description
#! gets the number of columns in the underlying commutative grid.
DeclareAttribute("NumCommGridColumns", IsCommGridPathAlgebra);
