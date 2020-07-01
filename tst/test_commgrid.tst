gap> A := CommGridPathAlgebra(GF(2), 2, 3);
<GF(2)[<quiver with 6 vertices and 7 arrows>]/<two-sided ideal in <GF(2)[<quiver with 6 vertices and 7 arrows>]>,(2 generators)>>

gap> NumCommGridRows(A);
2
gap> NumCommGridColumns(A);
3

gap> VerticesOfQuiver(QuiverOfPathAlgebra(A));
[ 1_1, 1_2, 1_3, 2_1, 2_2, 2_3 ]

gap> Length(IntervalDimVecs(A).1);
12
gap> Length(IntervalDimVecs(A).2);
15

gap> I := IntervalRepn(A, (IntervalDimVecs(A).2)[1]);;
gap> IsIndecomposableModule(I);
true
gap> IsCommGridInterval(I);
true