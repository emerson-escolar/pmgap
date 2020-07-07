gap> A := CommGridPathAlgebra(Rationals, 2, 3);;
gap> dim_v := [0,1,1,1,2,1];;

gap> matrices := [["1_2", "1_3", [[1]]], ["1_2","2_2", [[0,1]]], ["2_1","2_2", [[1,1]]], ["2_2","2_3", [[0],[1]]],["1_3","2_3", [[1]]]];;
gap> V := CommGridRepn(A, dim_v, matrices);
<[ 0, 1, 1, 1, 2, 1 ]>
gap> IsCommGridRepn(V);
true

gap> matrices_arrlbl := [["1_a_2", [[1]]], ["a_1_2", [[0,1]]], ["2_a_1", [[1,1]]], ["2_a_2", [[0],[1]]],["a_1_3", [[1]]]];;
gap> V := CommGridRepnArrLbl(A, dim_v, matrices_arrlbl);
<[ 0, 1, 1, 1, 2, 1 ]>
gap> IsCommGridRepn(V);
true
gap> V := RightModuleOverPathAlgebra(A, dim_v, matrices_arrlbl);
<[ 0, 1, 1, 1, 2, 1 ]>
gap> IsCommGridRepn(V);
true



gap> A := CommGridPathAlgebra(GF(8), 2, 3);;
gap> dim_v := [0,1,1,1,2,1];;

gap> matrices := [["1_2", "1_3", [[1]]], ["1_2","2_2", [[0,1]]], ["2_1","2_2", [[1,1]]], ["2_2","2_3", [[0],[1]]],["1_3","2_3", [[1]]]];;
gap> V := CommGridRepn(A, dim_v, matrices);
<[ 0, 1, 1, 1, 2, 1 ]>
gap> IsCommGridRepn(V);
true