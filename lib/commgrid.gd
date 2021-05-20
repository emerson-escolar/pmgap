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


# -------------------- Vertices and Arrows --------------------

#! @Arguments A
#! @Description
#! Gets a LookupDictionary with key [row_index, col_index]
#! associated to the corresponding vertex of the CommGridPathAlgebra A.
#! row_index (col_index, resp.) is an integer
#! between 1 and NumCommGridRows(A) (NumCommGridColumns(A), resp.)
#! @Returns LookupDictionary
DeclareAttribute("CommGridRowColumnToVertexDict", IsCommGridPathAlgebra);

#! @Arguments A
#! @Description
#! Gets a LookupDictionary with key [source_string, target_string]
#! associated to the corresponding arrow of (the quiver of) the CommGridPathAlgebra A.
#! source_string (target_string, resp.) is a string
#! corresponding to the source vertex (target vertex, resp.) of the arrow.
#! @Returns LookupDictionary
DeclareAttribute("CommGridSourceTargetToArrowDict", IsCommGridPathAlgebra);

#! @Arguments A, [row_index, col_index], direction
#! @Description
#! Gets the arrow of (the quiver of) the CommGridPathAlgebra A with source vertex
#! given by [row_index, col_index] and facing direction.
#! direction is a character 'r' or 'c',
#! with 'r' meaning that the target vertex has row index 1 larger than the source vertex,
#! and 'c' meaning that the target vertex has row index 1 larger than the source vertex.
#! @Returns arrow
DeclareOperation("CommGridRowColumnDirectionToArrow", [IsCommGridPathAlgebra, IsList, IsChar]);


DeclareOperation("CommGridPath", [IsCommGridPathAlgebra, IsList, IsList]);
