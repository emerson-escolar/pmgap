gap> A := CommGridPathAlgebra(GF(2),2,3);;
gap> intervals := IntervalRepnsList(A);;
gap> for I in intervals do
> Print(LengthOfComplex(HaveFiniteResolutionInAddMList(I, intervals, 3)));
> od;
222222222222222222222222222