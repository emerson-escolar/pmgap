#! @Chapter Underlying settings

#! @Section Commutative grids

# -------------------- 1D Grids --------------------
#! @Arguments field, num_vertices
#! @Returns an equioriented A_n path algebra
DeclareGlobalFunction("EquiorientedAnPathAlgebra");

#! @Arguments A
#! @Returns true or false
#! @Description
#! Tells you if A is equioriented A_n path algebra or not.
DeclareProperty("IsEquiorientedAnPathAlgebra", IsPathAlgebra);


# -------------------- 2D Grids --------------------
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


# TODO: A way to extract vertices using i,j index,
# and a way to extract arrows using source and target indices.

DeclareAttribute("CommGridSourceTargetToArrowDict", IsCommGridPathAlgebra);
