#
#These are test codes for calculating compress multiplicity defined in the paper
#"Approximation by interval-decomposables and interval resolutions of persistence modules"
#by Hideto Asashiba, Emerson G. Escolar, Ken Nakashima, Michio Yoshiwaki.
#See https://arxiv.org/abs/2207.03663
#The definition of the compressed multiplicity is in Definition 5.1 in the above paper.
#

CG:=CommGridPathAlgebra(GF(2), 2, 3);

#CG is like the bound quiver algebra made by
#4→5→6
#↑　↑　↑
#1→2→3
#

S:=IntervalRepnsList(CG);
CLIntervalrepr:=S[20];
#S[20]=111
#      111
#Q := Quiver(5,[[2,1,"a"],[2,3,"b"],[4,3,"c"],[4,5,"d"]]);
#kQ := PathAlgebra(GF(2), Q);
testCLa:=RightModuleOverPathAlgebra( CG, [1,2,3,4,5,6],
[ ["1_a_1",[ [ 0*Z(2), 0*Z(2) ] ] ],
["1_a_2", [ [Z(2)^0, 0*Z(2)^0, Z(2)^0 ], [ 0*Z(2)^0, 0*Z(2)^0, Z(2)^0 ] ] ],
  ["2_a_1",[ [ 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, Z(2)^0 ], [ Z(2)^0, Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2) ], 
  [ Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0 ], [ 0*Z(2), Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0 ] ] ], 
  ["2_a_2",[ [ Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, Z(2)^0 ], [ Z(2)^0, 0*Z(2), 0*Z(2), Z(2)^0, 0*Z(2), 0*Z(2) ],
  [ Z(2)^0, Z(2)^0, Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2) ], [ 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2), Z(2)^0, 0*Z(2) ],
  [ Z(2)^0, 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2), Z(2)^0 ]]],["a_1_1", [ [ 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2) ] ] ], 
  ["a_1_2", [ [ 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2) ], [ Z(2)^0, 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2) ] ]] 
  ,["a_1_3", [ [ Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, Z(2)^0 ], [ 0*Z(2), Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, 0*Z(2) ],
  [ Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, Z(2)^0 ]]] ]);
testCLb:=RightModuleOverPathAlgebra( CG, [0,1,1,1,2,1],[  ["2_a_1",[[1*Z(2) , 0*Z(2)^0 ]] ],["2_a_2",[[1*Z(2)^0 ], [0*Z(2)^0 ]] ],["1_a_2", [[1*Z(2)^0]] ],  ["a_1_2", [[1*Z(2)^0, 1*Z(2)^0]]] ,["a_1_3", [[1*Z(2)^0]] ] ]  );
testCLC:=RandomCommGridRepn([5,5,5,5,5,5], CG);
testCLd:=S[20];


CompressedMultiplicityVer2(testCLa,CLIntervalrepr);
CompressedMultiplicityVer2(testCLb,CLIntervalrepr);
CompressedMultiplicityVer2(testCLC,CLIntervalrepr);
CompressedMultiplicityVer2(testCLd,CLIntervalrepr);

for i in S do
  Print(CompressedMultiplicityVer2(testCLa,i)," ");
od;

for i in S do
  for j in S do
  Print(CompressedMultiplicityVer2(j,i)," ");
  od;
od;


##The code below gives a sequence of 1 like 1 1 1 ... 1 1． 
for i in S do
  Print(CompressedMultiplicityVer2(i,i)," ");
od;

#The code below will give us 0 because
#S[5]=000   S[7]=100
#     011        000
CompressedMultiplicityVer2(S[5],S[7]);


CompressedMultiplicityVer2List(testCLa);
