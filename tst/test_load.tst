gap> LoadPackage("pmgap", false);;
gap> dir := DirectoriesPackageLibrary("pmgap", "tst");;
gap> V := JsonFileToCommGridRepn(Filename(dir,"testrepn1.json"));
<[ 0, 1, 1, 1, 2, 1 ]>
gap> V := JsonFileToCommGridRepn(Filename(dir,"testrepnF.json"));
<[ 0, 1, 1, 1, 2, 1 ]>
gap> V := JsonFileToCommGridRepn(Filename(dir,"testrepnR.json"));
<[ 0, 1, 1, 1, 2, 1 ]>
gap> V := JsonFileToCommGridRepn(Filename(dir,"testrepnL.json"));
<[ 0, 1, 1, 1, 2, 1 ]>
gap> A := RightActingAlgebra(V);
<Rationals[<quiver with 6 vertices and 7 arrows>]/<two-sided ideal in <Rationals[<quiver with 6 vertices and 7 arrows>]>,(2 generators)>>