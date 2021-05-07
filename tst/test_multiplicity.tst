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




gap> LoadPackage("pmgap", false);;
gap> dir := DirectoriesPackageLibrary("pmgap", "tst");;
gap> V1 := JsonFileToCommGridRepn(Filename(dir,"001_pmgap_repn.json"));;
gap> A:= RightActingAlgebra(V1);;
gap> V2 := JsonFileToCommGridRepn(Filename(dir,"002_pmgap_repn.json"), A);;

gap> DimHomOverAlgebra(V1,V1) = Length(HomOverAlgebra(V1,V1));
true
gap> DimHomOverAlgebra(V1,V2) = Length(HomOverAlgebra(V1,V2));
true
gap> DimHomOverAlgebra(V2,V1) = Length(HomOverAlgebra(V2,V1));
true
gap> DimHomOverAlgebra(V2,V2) = Length(HomOverAlgebra(V2,V2));
true