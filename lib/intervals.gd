#! @Chapter Persistence modules (representations)

#! @Section Intervals

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
#! @BeginGroup IntervalRepn
#! @GroupTitle Interval representations
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
