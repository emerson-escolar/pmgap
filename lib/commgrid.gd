#! @Chapter Underlying settings

#! @Section Commutative grids

#! @Arguments field, num_rows, num_columns
#! @Returns a commutative grid path algebra
DeclareGlobalFunction("CommGridPathAlgebra");

#! @Arguments A
#! @Returns true or false
#! @Description
#! Tells you if A is commutative grid path algebra or not.
DeclareProperty("IsCommGridPathAlgebra", IsPathAlgebra);

#! @Arguments A
#! @Description
#! Gets the number of rows in the underlying commutative grid of A.
DeclareAttribute("NumCommGridRows", IsCommGridPathAlgebra);

#! @Arguments A
#! @Description
#! gets the number of columns in the underlying commutative grid of A.
DeclareAttribute("NumCommGridColumns", IsCommGridPathAlgebra);
