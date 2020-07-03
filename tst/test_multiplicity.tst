gap> A := CommGridPathAlgebra(GF(2), 2, 3);;
gap> L := [];;
gap> for dv in IntervalDimVecs(A).2 do
>        Add(L, IntervalRepn(A,dv));
>    od;
gap> M := DirectSumOfQPAModules(L);;

gap> for I in L do;
>        Print(MultiplicityAtIndec(M,I));
>    od;
111111111111111

gap> for dv in IntervalDimVecs(A).1 do;
>        Print(MultiplicityAtIndec(M,IntervalRepn(A,dv)));
>    od;
000000000000