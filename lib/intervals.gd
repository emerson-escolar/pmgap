#! @Chapter intervals

#! @Section Interval formats

#! Two ways of specifying interval representations are provided: the dimension vector format
#! and the row-wise birth-death format.
#!
#! <List>
#! <Item>
#! In the row-wise birth-death format, an interval is a list
#! with the $i$th entry given as:
#! a) a list with two elements <C>[birth_i, death_i]</C> corresponding to the
#!    endpoints of the $i$th row, if the ith row is non-empty, or
#! b) <C>false</C>, if the ith row is empty.
#! </Item>
#!
#! <Item>
#! In the dimension vector format, an interval is given as a list of dimensions (either $1$ or $0$) of the
#! vector spaces at the vertices of the underlying quiver.
#! Note that this depends on the vertices of <Ref Func="CommGridPathAlgebra"/> being ordered in a very specific way!
#! In terms of (row,col) indices, it is assumed to be ordered as:
#! (1,1) (1,2) ... (1,n_cols) (2,1) (2,2) ... (2,n_cols) (n_rows,1) (n_rows,2) ... (n_rows,n_cols).
#! </Item>
#! </List>
#!
#! There are additional requirements for being an interval.
#! See Proposition 4.1 and the definition of "staircases" in <Cite Key="asashiba2018interval"/> for more details.


# These are checked by the functions
# <Ref Oper="CheckRowWiseBD"/>, <Ref Oper="CheckCommGridIntervalDimVec"/>, <Ref Oper="CheckAnIntervalDimVec"/>.

# --------------------------------------------------
#! @Arguments rwbd, n_rows, n_cols
#! @Description
#! Checks whether or not the input row-wise-birth-death list (<A>rwbd</A>) represents
#! an interval representation over an <A>n_rows</A> $\times$ <A>n_cols</A>
#! equioriented commutative grid path algebra.
#!
#! Note that the interval representation nor the path algebra
#! need not be explicitly constructed.
#! @Returns true or false
DeclareOperation("CheckRowWiseBD", [IsList, IsInt, IsInt]);

# --------------------------------------------------
#! @Arguments dim_vec, n_rows, n_cols
#! @Description
#! Checks whether or not the input dimension vector (<A>dim_vec</A>) represents
#! an interval representation over an <A>n_rows</A> $\times$ <A>n_cols</A>
#! equioriented commutative grid path algebra.
#!
#! Note that the interval representation or the path algebra
#! do not need to be explicitly constructed.
#! @Returns true or false
DeclareOperation("CheckCommGridIntervalDimVec", [IsList, IsInt, IsInt]);

#! @Arguments dim_vec, n
#! @Description
#! Checks whether or not the input dimension vector (<A>dim_vec</A>) represents
#! an interval representation over a equioriented $A_n$ path algebra with
#! <A>n</A> vertices.
#!
#! Note that the interval representation or the path algebra
#! do not need to be explicitly constructed.
#! @Returns true or false
DeclareOperation("CheckAnIntervalDimVec", [IsList, IsInt]);


# --------------------------------------------------
#! @Arguments dim_vec, n_rows, n_cols
#! @Description
#! Converts the dimension vector (<A>dim_vec</A>) of an interval representation over
#! an <A>n_rows</A> $\times$ <A>n_cols</A> equioriented commutative grid path algebra
#! to the row-wise birth-death format.
#!
#! Note that the interval representation nor the path algebra
#! need not be explicitly constructed.
#! @Returns row-wise birth-death
DeclareOperation("IntervalDimVecToRowWiseBD", [IsList, IsInt, IsInt]);

# --------------------------------------------------
#! @Arguments rwbd, n_rows, n_cols
#! @Description
#! Converts the row-wise-birth-death list (<A>rwbd</A>) of an interval representation over
#! an <A>n_rows</A> $\times$ <A>n_cols</A> equioriented commutative grid path algebra to its dimension vector.
#!
#! Note that the interval representation nor the path algebra
#! need not be explicitly constructed.
#! @Returns dimension vector
DeclareOperation("RowWiseBDToIntervalDimVec", [IsList, IsInt, IsInt]);
# --------------------------------------------------

#! @Section Generating intervals

# --------------------------------------------------
#! @BeginGroup IntervalDimVecs
#! @GroupTitle Dimension vectors of intervals

#! @Description
#! Computes the dimension vectors, organized by "height",
#! of the interval representations of the given
#! <A>commutative_grid_path_algebra</A> or <A>equioriented_an_path_algebra</A>.
#! Here, the "height" of
#! an interval is defined to be the number of rows of the
#! commutative grid its support occupies.
#!
#! The return value is a GAP Record, with heights 1, 2, ...
#! as the record names, and Lists of
#! dimension vectors (also Lists) as record components.
#! @Returns Record of dimension vectors of intervals

#! @Arguments comm_grid_path_algebra
DeclareAttribute("IntervalDimVecs", IsCommGridPathAlgebra);
#! @Arguments equioriented_an_path_algebra
DeclareAttribute("IntervalDimVecs", IsEquiorientedAnPathAlgebra);
#! @EndGroup
# --------------------------------------------------


# --------------------------------------------------
#! @BeginGroup IntervalRepn
#! @GroupTitle Interval representation

#! @Description
#! This operation builds the interval representation of
#! a <A>commutative_grid_path_algebra</A> or <A>equioriented_an_path_algebra</A>
#! with dimension vector given by <A>dim_vec</A>.
#! @Returns interval representation

#! @Arguments commutative_grid_path_algebra, dim_vec
DeclareOperation("IntervalRepn", [IsCommGridPathAlgebra, IsCollection]);

#! @Arguments equioriented_an_path_algebra, dim_vec
DeclareOperation("IntervalRepn", [IsEquiorientedAnPathAlgebra, IsCollection]);
#! @EndGroup
# --------------------------------------------------


# --------------------------------------------------
#! @BeginGroup IntervalRepns
#! @GroupTitle Interval representations

#! @Description
#! Computes the interval representations, organized by "height",
#! of the interval representations of the given
#! <A>commutative_grid_path_algebra</A> or <A>equioriented_an_path_algebra</A>.
#! Here, the "height" of
#! an interval is defined to be the number of rows of the
#! commutative grid its support occupies.
#!
#! The return value is a &GAP; Record, with heights 1, 2, ...
#! as the record names, and Lists of
#! interval representations as record components.
#! @Returns Record of interval representations

#! @Arguments comm_grid_path_algebra
DeclareAttribute("IntervalRepns", IsCommGridPathAlgebra);
#! @Arguments equioriented_an_path_algebra
DeclareAttribute("IntervalRepns", IsEquiorientedAnPathAlgebra);
#! @EndGroup
# --------------------------------------------------


#! @Arguments V
#! @Returns true or false
#! @Description
#! Tells you if <A>V</A> is an interval or not.
DeclareProperty("IsCommGridInterval", IsCommGridRepn);
#!
InstallTrueMethod(IsIndecomposableModule, IsCommGridInterval);

#! @Arguments V
#! @Returns true or false
#! @Description
#! Tells you if <A>V</A> is an interval or not.
DeclareProperty("IsEquiorientedAnInterval", IsEquiorientedAnRepn);
#!
InstallTrueMethod(IsIndecomposableModule, IsEquiorientedAnInterval);


#! @Section Interval part of a persistence module
# --------------------------------------------------
# IntervalPart & Related Functions

#! @Arguments V
#! @Returns list
#! @Description
#! Computes the largest interval-decomposable summand of <A>V</A>.
#! The output is a list containing lists [interval_indecomposable, multiplicity]
#! giving the decomposition of the largest interval-decomposable summand of <A>V</A>.
#!
#! Uses the algorithm of <Cite Key="asashiba2018interval"/>.
#! Warning: non-obvious cases involve much computation.
DeclareAttribute("IntervalPart", IsCommGridRepn);

#! @Arguments V
#! @Returns dimension vector
#! @Description
#! Computes the dimension vector of the largest interval-decomposable summand of <A>V</A>
#!
#! Uses the algorithm of <Cite Key="asashiba2018interval"/>.
#! Warning: non-obvious cases involve much computation.
DeclareOperation("IntervalPartDimVec", [IsCommGridRepn]);

#! @Arguments V
#! @Returns true or false
#! @Description
#! Tells you if <A>V</A> is interval decomposable or not.
#!
#! Uses the algorithm of <Cite Key="asashiba2018interval"/>.
#! Warning: non-obvious cases involve much computation.
DeclareProperty("IsIntervalDecomposable", IsCommGridRepn);

InstallTrueMethod(IsIntervalDecomposable, IsEquiorientedAnRepn);
InstallTrueMethod(IsIntervalDecomposable, IsCommGridInterval);
# --------------------------------------------------


#! @Section Interval sources and sinks

# --------------------------------------------------
# Interval sources and sinks

#! @Arguments V
#! @Returns list of sources
#! @Description
#! Computes the source vertices of an interval representation V
#! of a commutative grid path algebra.
#! The output is a list, with entries [row_index_i, col_index_i]
#! corresponding to the indices of the source vertices of V.
DeclareOperation("SourceVertices", [IsCommGridInterval]);

#! @Arguments V
#! @Returns list of sinks
#! @Description
#! Computes the sink vertices of an interval representation V
#! of a commutative grid path algebra.
#! The output is a list, with entries [row_index_i, col_index_i]
#! corresponding to the indices of the sink vertices of V.
DeclareOperation("SinkVertices", [IsCommGridInterval]);



#! @Section Interval local lattice computations

# --------------------------------------------------
#! @Arguments rwbd, n_rows, n_cols
#! @Description Generate cover of an interval, in row-wise birth-death format.
#!
#! Note that the interval representation nor the path algebra
#! need not be explicitly constructed.
#! @Returns list of cover intervals
DeclareOperation("CoverOfRowWiseBD", [IsList, IsInt, IsInt]);

#! @Arguments rwbd, n_rows, n_cols
#! @Description Generate joins of subsets of the cover of an interval,
#! in row-wise birth-death format.
#!
#! Note that the interval representation nor the path algebra
#! need not be explicitly constructed.
#! @Returns list of intervals
DeclareOperation("JoinCoverSubsetsOfRowWiseBD", [IsList, IsInt, IsInt]);


