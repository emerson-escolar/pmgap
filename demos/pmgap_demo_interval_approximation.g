# force gap to quit with error state on error.
OnBreak := function()
    Where();
    QUIT_GAP(1);
end;;

LoadPackage("pmgap");;


Print("********************************************************************************\n");
Print("Demo program for computations described in\n\"On Approximation of 2D Persistence Modules by Interval-decomposables\".\n");
Print("********************************************************************************\n");

Print("1. Example 5.6 of the paper..\n");
Print("The representation M is stored in the file interval_approx_example_5.6.json.\n\n");
Print("The file is a json file defining the representation. Contents:\n");
fstream := InputTextFile("interval_approx_example_5.6.json");
Print(ReadAll(fstream));
CloseStream(fstream);

M := JsonFileToCommGridRepn("interval_approx_example_5.6.json");

Print("\nBelow, we compute the compressed multiplicity of M and its interval-decomposable approximation.\n\n");

Print("Compressed Multiplicity:\n");
# View(CompressedMultiplicity(M));
for entry in CompressedMultiplicity(M) do
    View(entry);
    Print("\n");
od;
Print("\n");

Print("Interval Approximation:\n");
# View(IntervalApproximation(M));
for entry in IntervalApproximation(M) do
    View(entry);
    Print("\n");
od;
Print("\n");
Print("\nThe dimension vectors of the intervals given in Example 5.6 of the paper are\nI1 = [0,1,1,1,1,0]\nI2 = [0,1,1,1,1,1]\nI3 = [0,1,1,0,1,0]\nI4 = [0,0,0,1,1,0]\n");

Print("********************************************************************************\n");
Print("2. Larger example..\n");

Print("Let us consider the representation M in file interval_approx_example_2by6.json.\n\n");
M := JsonFileToCommGridRepn("interval_approx_example_2by6.json");

Print("The underlying grid is of size 2x6, and M has dimension vector\n");
Print(DimensionVector(M));
Print("\n\n");

Print("Using the algorithm presented in the paper\n");
Print("\"On Approximation of 2D Persistence Modules by Interval-decomposables\",\n");
Print("we compute that the dimension vector of the interval part of M is:\n");
Print(IntervalPartDimVec(M));
Print("\nshowing us that M is not interval-decomposable.\n\nIn fact, the interval part decomposes as:\n--computation may take some time--\n");
Print("\n");
for entry in IntervalPart(M) do
    View(entry);
    Print("\n");
od;

Print("\nThis time, we skip showing the compressed multiplicity.\n");
Print("The interval approximation is:\n");
# View(IntervalApproximation(M));
for entry in IntervalApproximation(M) do
    View(entry);
    Print("\n");
od;
Print("\n");

QUIT_GAP(0);
