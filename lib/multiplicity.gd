#! @Chapter representations

#! @Section Useful operations

#! @Description
#! Computes the multiplicity of an indecomposable module <A>I</A>
#! as direct summand of the QPA <C>PathAlgebraMatModule</C> <A>M</A>.
#! Currently uses the algorithm of computing dimensions of hom spaces to the Auslander-Reiten mesh of <A>I</A>.
#! See <Cite Key="asashiba2017"/>, <Cite Key="dowbor2007multiplicity"/>.
#! @Returns multiplicity

#! @Arguments M, I
DeclareOperation("MultiplicityAtIndec",
                 [IsPathAlgebraMatModule, IsIndecomposableModule]);

#! @Description
#! Computes the multiplicities of the indecomposable modules in <A>list_of_indec_modules</A> as direct summands of
#! the QPA <C>PathAlgebraMatModule</C> <A>M</A>.
#! Currently uses the algorithm of computing dimensions of hom spaces to the Auslander-Reiten mesh of <A>I</A>.
#! See <Cite Key="asashiba2017"/>, <Cite Key="dowbor2007multiplicity"/>.

#! @Arguments M, list_of_indec_modules
#! @Returns list of lists [I, multiplicity(I)]
DeclareOperation("ComputeMultiplicities",
                 [IsPathAlgebraMatModule, IsListOrCollection]);


#! @Description
#! Computes the dimension of the homomorphism space $Hom_A(M,N)$ for
#! two <C>PathAlgebraMatModule</C>s over the same algebra $A$.
#! @Arguments M,N
#! @Returns dimension
DeclareOperation("DimHomOverAlgebra", [IsPathAlgebraMatModule, IsPathAlgebraMatModule]);
