#! @Chapter utils

#! @Section Vector spaces and linear maps

#! @Description pullback
#! @Arguments Af, Ag
#! @Returns pullback
DeclareOperation("PullbackMatrices", [IsMatrix, IsMatrix]);


DeclareOperation("StackMatricesHorizontalConcat", [IsMatrix, IsMatrix]);
DeclareOperation("StackMatricesVerticalConcat", [IsMatrix, IsMatrix]);

DeclareOperation("StackMatricesHorizontalCopy", [IsMatrix, IsMatrix]);
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
