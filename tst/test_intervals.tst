# *** Interval dimension vectors and Row-wise birth-death format ***

# some non-intervals for 4x3 grid

gap> bad_dim_vecs := [[0,0,0, 0,0,0, 0,0,0, 0,0,0],
>                     [0,0,1, 1,1,0, 0,0,0, 0,0,0],
>                     [0,0,1, 0,0,0, 0,0,0, 0,0,1],
>                     [1,1,1, 0,1,0, 0,0,0, 0,0,1],
>                     [0,0,1, 0,0,0, 0,0,0, 0,0,0,0],
>                     [0,0,1, 0,0,0, 0,0,0, 0,0],
>                     [0,0,2, 0,0,0, 0,0,0, 0,0,0]];;
gap> for dimv in bad_dim_vecs do
>        Display(CheckCommGridIntervalDimVec(dimv,4,3));
>    od;
false
false
false
false
false
false
false
gap> for dimv in bad_dim_vecs do
>        Display(IntervalDimVecToRowWiseBD(dimv,4,3));
>    od;
fail
fail
fail
fail
fail
fail
fail

gap> bad_rwbd := [[false,[1,1],false,[1,1]],
>                 [false,false,false,false],
>                 [[3,3],[1,2],false,false],
>                 [false,[4,4],false,false],
>                 [false,[0,3],false,false],
>                 [false,"bd",false,false],
>                 [false,[1,1],[1,1],false,false],
>                 [false,[1,1],[1,1]]];;
gap> for rwbd in bad_rwbd do
>        Display(CheckRowWiseBD(rwbd,4,3));
>    od;
false
false
false
false
false
false
false
false
gap> for rwbd in bad_rwbd do
>        Display(RowWiseBDToIntervalDimVec(rwbd,4,3));
>    od;
fail
fail
fail
fail
fail
fail
fail
fail


gap> dim_vecs := [[0,0,1, 0,0,0, 0,0,0, 0,0,0],
>                 [0,0,1, 0,1,1, 1,1,0, 1,0,0],
>                 [0,0,0, 0,1,1, 1,1,0, 0,0,0],
>                 [1,1,1, 1,1,1, 1,1,1, 1,1,1]];;
gap> rwbd_vecs := [[[3,3], false, false, false],
>                  [[3,3], [2,3], [1,2], [1,1]],
>                  [false, [2,3], [1,2], false],
>                  [[1,3], [1,3], [1,3], [1,3]]];;
gap> for dimv in dim_vecs do
>        Display(CheckCommGridIntervalDimVec(dimv,4,3));
>    od;
true
true
true
true
gap> for rwbd in rwbd_vecs do
>        Display(CheckRowWiseBD(rwbd,4,3));
>    od;
true
true
true
true
gap> List(dim_vecs, x->(IntervalDimVecToRowWiseBD(x,4,3))) = rwbd_vecs;
true
gap> List(rwbd_vecs, x->(RowWiseBDToIntervalDimVec(x,4,3))) = dim_vecs;
true




# ****** Interval representations ******

# intervals for A_5
gap> A5 := EquiorientedAnPathAlgebra(Rationals, 5);;
gap> Length(IntervalDimVecs(A5).1);
15
gap> for dv in IntervalDimVecs(A5).1 do
>        IntervalRepn(A,dv);
>    od;

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


# Number of intervals for 2x3 grid
gap> A := CommGridPathAlgebra(GF(2), 2, 3);;
gap> Length(IntervalDimVecs(A).1);
12
gap> Length(IntervalDimVecs(A).2);
15
gap> Length(IntervalRepns(A).1);
12
gap> Length(IntervalRepns(A).2);
15

gap> I := IntervalRepn(A, (IntervalDimVecs(A).2)[1]);;
gap> IsIndecomposableModule(I);
true
gap> IsCommGridInterval(I);
true

# Generate intervals for 4x3 grid
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



# ****** Interval Decomposability ******

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


# ****** Source Sink Vertices ******
gap> A := CommGridPathAlgebra(GF(2), 4, 3);;
gap> I := IntervalRepn(A, [0,0,1, 0,1,1, 1,1,0, 1,0,0]);;
gap> SourceVertices(I);
[[1,3],[2,2],[3,1]]
gap> SinkVertices(I);
[[2,3],[3,2],[4,1]]

gap> I := IntervalRepn(A, [0,0,0, 0,0,1, 0,0,0, 0,0,0]);;
gap> SourceVertices(I);
[[2,3]]
gap> SinkVertices(I);
[[2,3]]

gap> I := IntervalRepn(A, [0,0,0, 0,1,0, 0,1,0, 0,0,0]);;
gap> SourceVertices(I);
[[2,2]]
gap> SinkVertices(I);
[[3,2]]