gap> A := CommGridPathAlgebra(GF(2), 2, 3);
<GF(2)[<quiver with 6 vertices and 7 arrows>]/<two-sided ideal in <GF(2)[<quiver with 6 vertices and 7 arrows>]>,(2 generators)>>

gap> Length(IntervalDimVecs(A).1);
12
gap> Length(IntervalDimVecs(A).2);
15

gap> I := IntervalRepn(A, (IntervalDimVecs(A).2)[1]);;
gap> IsIndecomposableModule(I);
true
gap> IsCommGridInterval(I);
true