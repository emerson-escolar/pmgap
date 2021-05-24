#! @Chapter Persistence modules (representations)

#! @Section Intervals

# --------------------------------------------------
#! @Arguments dim_vec, n_rows, n_cols
#! @Description
#! Converts the dimension vector (dim_vec) of an interval representation over
#! an n_rows x n_cols comm_grid_path_algebra to the row-wise birth-death
#! format.
#!
#! In the row-wise birth-death format, an interval is a list
#! with the ith entry given as:
#! a) a list with two elements [birth_i, death_i] corresponding to the
#!    endpoints of the ith row, if the ith row is non-empty, or
#! b) false, if the ith row is empty.
#!
#! Note that the interval representation nor the comm_grid_path_algebra
#! need not be explicitly constructed.
#! @Returns row-wise birth-death
DeclareOperation("IntervalDimVecToRowWiseBD", [IsList, IsInt, IsInt]);

# --------------------------------------------------
#! @Arguments rwbd, n_rows, n_cols
#! @Description
#! Converts the row-wise-birth-death list (rwbd) of an interval representation over
#! an n_rows x n_cols comm_grid_path_algebra to its dimension vector.
#!
#! In the row-wise birth-death format, an interval is a list
#! with the ith entry given as:
#! a) a list with two elements [birth_i, death_i] corresponding to the
#!    endpoints of the ith row, if the ith row is non-empty, or
#! b) false, if the ith row is empty.
#!
#! Note that the interval representation nor the comm_grid_path_algebra
#! need not be explicitly constructed.
#! @Returns dimension vector
DeclareOperation("RowWiseBDToIntervalDimVec", [IsList, IsInt, IsInt]);

# --------------------------------------------------
#! @Arguments rwbd, n_rows, n_cols
#! @Description
#! Checks whether or not the input row-wise-birth-death list (rwbd) represents
#! an interval representation over an n_rows x n_cols comm_grid_path_algebra.
#!
#! In the row-wise birth-death format, an interval is a list
#! with the ith entry given as:
#! a) a list with two elements [birth_i, death_i] corresponding to the
#!    endpoints of the ith row, if the ith row is non-empty, or
#! b) false, if the ith row is empty.
#!
#! Note that the interval representation nor the comm_grid_path_algebra
#! need not be explicitly constructed.
#! @Returns true or false
DeclareOperation("CheckRowWiseBD", [IsList, IsInt, IsInt]);

# --------------------------------------------------
#! @Arguments dim_vec, n_rows, n_cols
#! @Description
#! Checks whether or not the input dimension vector (dim_vec) represents
#! an interval representation over an n_rows x n_cols comm_grid_path_algebra.
#!
#! Note that the interval representation nor the comm_grid_path_algebra
#! need not be explicitly constructed.
#! @Returns true or false
DeclareOperation("CheckCommGridIntervalDimVec", [IsList, IsInt, IsInt]);

#! @Arguments dim_vec, n
#! @Description
#! Checks whether or not the input dimension vector (dim_vec) represents
#! an interval representation over a equioriented A_n path algebra with
#! n vertices.
#!
#! Note that the interval representation nor the path_algebra
#! need not be explicitly constructed.
#! @Returns true or false
DeclareOperation("CheckAnIntervalDimVec", [IsList, IsInt]);
# --------------------------------------------------


# --------------------------------------------------
#! @BeginGroup IntervalDimVecs
#! @GroupTitle Dimension vectors of intervals

#! @Description
#! Computes the dimension vectors, organized by "height",
#! of the interval representations of the given
#! equioriented An or commutative grid path algebra.
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
#! @Arguments commutative_grid_path_algebra, dimension_vector
#! @Returns interval representation

#! @Description
#! This operation builds the representation of A corresponding
#! to the dimension vector of an interval.
DeclareOperation("IntervalRepn", [IsCommGridPathAlgebra, IsCollection]);

#! @Arguments equioriented_an_path_algebra, dimension_vector
DeclareOperation("IntervalRepn", [IsEquiorientedAnPathAlgebra, IsCollection]);
#! @EndGroup
# --------------------------------------------------


# --------------------------------------------------
#! @BeginGroup IntervalRepns
#! @GroupTitle Interval representations

#! @Description
#! Computes the interval representations, organized by "height",
#! of the interval representations of the given
#! equioriented An or commutative grid path algebra.
#! Here, the "height" of
#! an interval is defined to be the number of rows of the
#! commutative grid its support occupies.
#!
#! The return value is a GAP Record, with heights 1, 2, ...
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
#! Tells you if V is an interval or not.
DeclareProperty("IsCommGridInterval", IsCommGridRepn);
#!
InstallTrueMethod(IsIndecomposableModule, IsCommGridInterval);

#! @Arguments V
#! @Returns true or false
#! @Description
#! Tells you if V is an interval or not.
DeclareProperty("IsEquiorientedAnInterval", IsEquiorientedAnRepn);
#!
InstallTrueMethod(IsIndecomposableModule, IsEquiorientedAnInterval);


# --------------------------------------------------
# IntervalPart & Related Functions

#! @Arguments V
#! @Returns list
#! @Description
#! Computes the largest interval-decomposable summand of V.
#! The output is a list containing lists [interval_repn, multiplicity]
#! giving the decomposition of the largest interval-decomposable summand of V.
#! Warning: non-obvious cases involve much computation
DeclareAttribute("IntervalPart", IsCommGridRepn);

#! @Arguments V
#! @Returns dimension vector
#! @Description
#! Computes the dimension vector of the largest interval-decomposable summand of V
#! Warning: non-obvious cases involve much computation
DeclareOperation("IntervalPartDimVec", [IsCommGridRepn]);

#! @Arguments V
#! @Returns true or false
#! @Description
#! Tells you if V is interval decomposable or not.
#! Warning: non-obvious cases involve much computation
DeclareProperty("IsIntervalDecomposable", IsCommGridRepn);

InstallTrueMethod(IsIntervalDecomposable, IsEquiorientedAnRepn);
InstallTrueMethod(IsIntervalDecomposable, IsCommGridInterval);
# --------------------------------------------------


# --------------------------------------------------
# Sources and Sinks
DeclareOperation("SourceVertices", [IsCommGridInterval]);
DeclareOperation("SinkVertices", [IsCommGridInterval]);
