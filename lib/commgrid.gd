#! @Chapter underlying

#! Chapter <Ref Chap='Chapter_underlying' Style='Number'/> describes various functions for the underlying
#! path algebras of the representions on which &pmgap; operates on.
#!
#! Most &pmgap; functions work on objects with underlying path algebra created by function
#! <Ref Func='EquiorientedAnPathAlgebra'/> or <Ref Func='CommGridPathAlgebra'/>.
#! That is, some &pmgap; functions may not work even if the underlying path algebra is
#! mathematically equivalent to one that would have been created by
#! <Ref Func='EquiorientedAnPathAlgebra'/> or <Ref Func='CommGridPathAlgebra'/>.

# -------------------- 1D Grids --------------------
#! @Section Equioriented 1D grids
#! Convenience functions for working with equioriented $1$D grids, i.e. equioriented $A_n$-type quivers.

#! @Description Creates the path algebra of an equioriented $A_n$-type quiver with <A>n</A> vertices
#! @Arguments field, n
#! @Returns equioriented $A_n$ path algebra
DeclareGlobalFunction("EquiorientedAnPathAlgebra");

#! @Arguments A
#! @Returns true or false
#! @Description
#! Tells you if <A>A</A> is an equioriented $A_n$ path algebra created by
#! <Ref Func='EquiorientedAnPathAlgebra'/>.
DeclareProperty("IsEquiorientedAnPathAlgebra", IsPathAlgebra);


# -------------------- 2D Grids --------------------
#! @Section Equioriented commutative 2D grids
#! Convenience functions for working with equioriented commutative $2$D grids,
#! i.e. the tensor product of the path algebras of two $A_n$-type quivers.

#! @Arguments field, n, m
#! @Returns an $n \times m$ commutative grid path algebra
DeclareGlobalFunction("CommGridPathAlgebra");

#! @Arguments A
#! @Returns true or false
#! @Description
#! Tells you if <A>A</A> is an equioriented commutative grid path algebra created by
#! <Ref Func='CommGridPathAlgebra'/>.
DeclareProperty("IsCommGridPathAlgebra", IsPathAlgebra);

#! @Arguments A
#! @Returns the number of rows in the underlying commutative grid of <A>A</A>.
DeclareAttribute("NumCommGridRows", IsCommGridPathAlgebra);

#! @Arguments A
#! @Returns the number of columns in the underlying commutative grid of <A>A</A>.
DeclareAttribute("NumCommGridColumns", IsCommGridPathAlgebra);

#! @Section Vertices and arrows

# -------------------- Vertices and Arrows --------------------
#! Here, we describe several convenience attributes for obtaining
#! vertices, arrows, and paths in commutative grids.


#! @Arguments A
#! @Description
#! Gets a LookupDictionary with key <C>[row_index, col_index]</C>
#! associated to the corresponding vertex of <A>A</A>.
#! Each <C>row_index</C> (<C>col_index</C>, resp.) is an integer
#! between $1$ and <C>NumCommGridRows(A)</C> (<C>NumCommGridColumns(A)</C>, resp.)
#! @Returns row-column to vertex lookup dictionary
DeclareAttribute("CommGridRowColumnToVertexDict", IsCommGridPathAlgebra);

#! @Arguments A
#! @Description
#! Gets a LookupDictionary with key <C>[source_string, target_string]</C>
#! associated to the corresponding arrow of the quiver of <A>A</A>.
#! Each <C>source_string</C> (<C>target_string</C>, resp.) is the <C>String</C>
#! representation of the source vertex (target vertex, resp.) of the arrow.
#! @Returns source-target to arrow lookup dictionary
DeclareAttribute("CommGridSourceTargetToArrowDict", IsCommGridPathAlgebra);

#! @Arguments A, source, direction
#! @Description
#! Gets the arrow of (the quiver of) <A>A</A> with <A>source</A>
#! given by <C>[row_index, col_index]</C> and facing <A>direction</A>,
#! which should be a character <C>'r'</C> or <C>'c'</C>,
#! with <C>'r'</C> meaning that the target vertex has row index $1$ more than the source vertex,
#! and <C>'c'</C> meaning that the target vertex has row index $1$ more than the source vertex.
#! @Returns arrow
DeclareOperation("CommGridRowColumnDirectionToArrow", [IsCommGridPathAlgebra, IsList, IsChar]);


#! @Arguments A, source, target
#! @Description
#! Gets a single path of the quiver of <A>A</A>
#! with <C>source = [source_row_index, source_col_index]</C>
#! and <C>target = [target_row_index, target_col_index]</C>.
#! Which path is returned by this function may be subject to change, depending on the underlying implementation!
#! Do not rely on the specific path.
#! @Returns path
DeclareOperation("CommGridPath", [IsCommGridPathAlgebra, IsList, IsList]);
