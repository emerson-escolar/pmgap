#! @Chapter utils

#! @Section Matrices

#! @Description pullback
#! @Arguments Af, Ag
#! @Returns pullback
DeclareOperation("PullbackMatrices", [IsMatrix, IsMatrix]);


#! @Arguments M1, M2
#! @Description
#! Stack the two matrices <A>M1</A> and <A>M2</A> horizontally to obtain the matrix
#! @LatexOnly $\left[\begin{array}{cc} M1 &  M2 \end{array}\right]$.
#! @Returns matrix
DeclareOperation("StackMatricesHorizontalCopy", [IsMatrix, IsMatrix]);

#! @Arguments M1, M2
#! @Description
#! Stack the two matrices <A>M1</A> and <A>M2</A> vertically to obtain the matrix
#! $\left[\begin{array}{c} M1 \\ M2 \end{array}\right]$.
#! @Returns matrix
DeclareOperation("StackMatricesVerticalCopy", [IsMatrix, IsMatrix]);



#! @Arguments [rs ,] m, n, k [, R]
#! @Description
#! <Ref Func="RandomMatFixedRank"/> returns a new mutable random
#!  matrix with <A>m</A> rows, <A>n</A> columns, and rank <A>k</A>
#! with elements taken from the ring
#!  <A>R</A>, which defaults to Integers.
#!  Optionally, a random source <A>rs</A> can be supplied.
DeclareGlobalFunction("RandomMatFixedRank");


#! @Arguments [rs ,] m, n [, rank_rs, R]
#! @Description
#! <Ref Func="RandomMatRandomRank"/> returns a new mutable random
#!  matrix with <A>m</A> rows, <A>n</A> columns, and
#! rank randomly chosen between 0 and min(m,n),
#! with elements taken from the ring
#!  <A>R</A>, which defaults to Integers.
#!  Optionally, a random source <A>rs</A> (for the matrix entries) and/or
#! a random source <A>rank_rs</A> (for the rank) can be supplied.
DeclareGlobalFunction("RandomMatRandomRank");
