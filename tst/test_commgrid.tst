gap> A := CommGridPathAlgebra(Rationals, 2, 3);
<Rationals[<quiver with 6 vertices and 7 arrows>]/<two-sided ideal in <Rationals[<quiver with 6 vertices and 7 arrows>]>,(2 generators)>>

gap> A := CommGridPathAlgebra(GF(2), 2, 3);
<GF(2)[<quiver with 6 vertices and 7 arrows>]/<two-sided ideal in <GF(2)[<quiver with 6 vertices and 7 arrows>]>,(2 generators)>>

gap> IsCommGridPathAlgebra(A);
true
gap> NumCommGridRows(A);
2
gap> NumCommGridColumns(A);
3

gap> VerticesOfQuiver(QuiverOfPathAlgebra(A));
[ 1_1, 1_2, 1_3, 2_1, 2_2, 2_3 ]


gap> B := EquiorientedAnPathAlgebra(Rationals, 5);
<Rationals[<quiver with 5 vertices and 4 arrows>]>
gap> IsEquiorientedAnPathAlgebra(B);
true