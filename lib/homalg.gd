#! @Chapter homalg

#! @Section Approximation


#! @BeginGroup HaveFiniteResolutionInAddMList
#! @GroupTitle HaveFiniteResolutionInAddMList

#! @Description
#! This function checks if the module  <A>N</A>  has a finite resolution
#! in the additive closure of the modules in the list <A>L</A> of length at most  <A>n</A>.
#! If it does, then this resolution is returned, otherwise false is returned.
#!
#! The second version of this function accepts an IsBool (true or false) as a fourth parameter.
#! If this is true, the dimension vectors of the entries of the resolution are printed as they are computed.
#!
#! This is modified from the QPA function HaveFiniteResolutionInAddM to work with list input.

#! @Returns a Complex or false

#! @Arguments N, L, n
DeclareOperation("HaveFiniteResolutionInAddMList", [IsPathAlgebraMatModule, IsList, IsInt]);

#! @Arguments N, L, n, verbose
DeclareOperation("HaveFiniteResolutionInAddMList", [IsPathAlgebraMatModule, IsList, IsInt, IsBool]);
#! @EndGroup


#! @Arguments L, C
#! @Description
#! Given a list of module L over a finite dimensional quotient A of
#! a path algebra and a module C over  A, this function computes
#! a right approximation of C in the additive closure of the modules
#! in the list L.
#!
#! This is modified from the QPA function RightApproximationByAddM,

DeclareOperation("RightApproximationByAddMCustom", [ IsList, IsPathAlgebraMatModule ] );
