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


gap> B := EquiorientedAnPathAlgebra(GF(2), 5);;
gap> I := IntervalRepn(B, [0,1,1,1,0]);
<[0,1,1,1,0]>
gap> IsIndecomposableModule(I);
true
gap> IsEquiorientedAnInterval(I);
true

gap> I := IntervalRepn(B, [0,1,0,1,0]);
fail
