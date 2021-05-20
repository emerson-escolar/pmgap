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

# Order of vertices is important! see intervals.gi
gap> VerticesOfQuiver(QuiverOfPathAlgebra(A));
[ 1_1, 1_2, 1_3, 2_1, 2_2, 2_3 ]

gap> d := CommGridRowColumnToVertexDict(A);;
gap> for i in [1..2] do
> for j in [1..3] do
> v := LookupDictionary(d, [i,j]);;
> Display(SourceVertex(v) = v);
> Display(TargetVertex(v) = v);
> od;
> od;
true
true
true
true
true
true
true
true
true
true
true
true

gap> p := CommGridPath(A, [1,1],[2,3]);;
gap> SourceVertex(p) = LookupDictionary(d,[1,1]);
true
gap> TargetVertex(p) = LookupDictionary(d,[2,3]);
true


gap> B := EquiorientedAnPathAlgebra(Rationals, 5);
<Rationals[<quiver with 5 vertices and 4 arrows>]>
gap> IsEquiorientedAnPathAlgebra(B);
true