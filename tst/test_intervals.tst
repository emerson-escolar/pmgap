gap> A5 := EquiorientedAnPathAlgebra(Rationals, 5);;
gap> Length(IntervalDimVecs(A5).1);
15
gap> for dv in IntervalDimVecs(A5).1 do
>        IntervalRepn(A,dv);
>    od;


gap> A := CommGridPathAlgebra(GF(2), 2, 3);;

gap> Length(IntervalDimVecs(A).1);
12
gap> Length(IntervalDimVecs(A).2);
15

gap> I := IntervalRepn(A, (IntervalDimVecs(A).2)[1]);;
gap> IsIndecomposableModule(I);
true
gap> IsCommGridInterval(I);
true

gap> A := CommGridPathAlgebra(GF(2), 4, 3);;
gap> for name in RecNames(IntervalDimVecs(A)) do
>    for dv in IntervalDimVecs(A).(name) do
>        IntervalRepn(A,dv);
>    od;
> od;

gap> IntervalRepn(A,[0,0,0,0,0,0,0,0,0,0,0,0]);
fail
gap> IntervalRepn(A,[0,0,1,1,1,0,0,0,0,0,0,0]);
fail
gap> IntervalRepn(A,[0,0,1,0,0,0,0,0,0,0,0,1]);
fail
gap> IntervalRepn(A,[1,1,1,0,1,0,0,0,0,0,0,1]);
fail




gap> B := EquiorientedAnPathAlgebra(GF(2), 5);;
gap> I := IntervalRepn(B, [0,1,1,1,0]);
<[0,1,1,1,0]>
gap> IsIndecomposableModule(I);
true
gap> IsEquiorientedAnInterval(I);
true

gap> IntervalRepn(B, [0,1,0,1,0]);
fail
gap> IntervalRepn(B, [0,0,0,0,0]);
fail
gap> IntervalRepn(B, [0,0,0]);
fail
gap> IntervalRepn(B, [0,0,0,1,1,1,1]);
fail



gap> dir := DirectoriesPackageLibrary("pmgap", "tst");;
gap> V := JsonFileToCommGridRepn(Filename(dir,"testrepn1.json"));;
gap> IsIntervalDecomposable(V);
false

gap> A := CommGridPathAlgebra(GF(2), 2, 3);;
gap> L := [];;
gap> for dv in IntervalDimVecs(A).2 do
>        Add(L, IntervalRepn(A,dv));
>    od;
gap> M := DirectSumOfQPAModules(L);;
gap> IsIntervalDecomposable(M);
true