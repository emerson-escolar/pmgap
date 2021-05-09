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

gap> Vreload := JsonFileToCommGridRepn(Filename(dir,"testrepnL.json"), A);
<[ 0, 1, 1, 1, 2, 1 ]>
gap> RightActingAlgebra(V) = RightActingAlgebra(Vreload);
true

gap> V_OtherField := JsonFileToCommGridRepn(Filename(dir,"testrepnF.json"), A);
fail



gap> L := JsonFilesToCommGridRepn([Filename(dir,"001_pmgap_repn.json"), Filename(dir,"002_pmgap_repn.json")]);
[ <[ 1, 4, 20, 16, 58, 65 ]>, <[ 0, 1, 9, 26, 61, 71 ]> ]