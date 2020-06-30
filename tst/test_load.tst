gap> LoadPackage("pmgap", false);;
gap> dir := DirectoriesPackageLibrary("pmgap", "tst");;
gap> A := JsonFileToCommGridRepn(Filename(dir,"testrepn1.json"));
<[ 0, 1, 1, 1, 2, 1 ]>
gap> A := JsonFileToCommGridRepn(Filename(dir,"testrepnF.json"));
<[ 0, 1, 1, 1, 2, 1 ]>
gap> A := JsonFileToCommGridRepn(Filename(dir,"testrepnR.json"));
<[ 0, 1, 1, 1, 2, 1 ]>
gap> A := JsonFileToCommGridRepn(Filename(dir,"testrepnL.json"));
<[ 0, 1, 1, 1, 2, 1 ]>

