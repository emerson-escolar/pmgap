gap> RankMat(RandomMatFixedRank(5,5,3));
3

gap> RankMat(RandomMatFixedRank(5,6,0, GF(2)));
0
gap> RankMat(RandomMatFixedRank(5,6,1, GF(2)));
1
gap> RankMat(RandomMatFixedRank(5,6,2, GF(2)));
2
gap> RankMat(RandomMatFixedRank(5,6,3, GF(2)));
3
gap> RankMat(RandomMatFixedRank(5,6,4, GF(2)));
4
gap> RankMat(RandomMatFixedRank(5,6,5, GF(2)));
5

gap> A := RandomMatFixedRank(10,11,4);;
gap> B := RandomMatFixedRank(9,11,4);;
gap> pb := PullbackMatrices(A,B);;
gap> K := (pb[1] * A - pb[2] * B);;
gap> K = NullMat(DimensionsMat(K)[1], 11);
true

