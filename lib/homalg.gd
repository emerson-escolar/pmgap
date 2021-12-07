#! @Chapter homalg

#! @Section Approximation

#! @Arguments N, L, n
#! @Returns true or false
#! @Description
#! This function checks if the module  <A>N</A>  has a finite resolution
#! in the additive closure of the modules in the list <A>L</A> of length at most  <A>n</A>.
#! If it does, then this resolution is returned, otherwise false is returned.
#!
#! This is modified from the QPA function HaveFiniteResolutionInAddM to work with list input.
DeclareOperation("HaveFiniteResolutionInAddMList", [IsPathAlgebraMatModule, IsList, IsInt]);


#! @Arguments L, C
#! @Description
#! Given a list of module L over a finite dimensional quotient A of
#! a path algebra and a module C over  A, this function computes
#! a right approximation of C in the additive closure of the modules
#! in the list L.
#!
#! This is modified from the QPA function RightApproximationByAddM,

DeclareOperation("RightApproximationByAddMCustom", [ IsList, IsPathAlgebraMatModule ] );
