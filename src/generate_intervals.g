# A_CODE="computeseq := false;;"
# N_CODE="writeoutput := true;;"



generate_name := function(I)
    local ans, A, d;
    ans := "";
    A := RightActingAlgebra(I);
    ans := JoinStringsWithSeparator([String(NumCommGridRows(A)), String(NumCommGridColumns(A)), ""],"_");

    for d in DimensionVector(I) do
        ans := Concatenation(ans, String(d));
    od;

    return ans;
end;




for height in RecNames(IntervalRepns(A)) do
    for I in IntervalRepns(A).(height) do
        products := [ ["I", I] ];

        if computeseq then
            asseq := AlmostSplitSequence(I);
            if asseq = fail then
                # I is projective!
                rad := RadicalOfModule(I);
                SetFilterObj(rad, IsCommGridRepn);
                Add(products, ["RAD", rad]);
            else
                middleterm := Range(asseq[1]);
                SetFilterObj(middleterm, IsCommGridRepn);
                tauI := Source(asseq[1]);
                SetFilterObj(tauI, IsCommGridRepn);
                Add(products, ["MID", middleterm]);
                Add(products, ["TAU", tauI]);
            fi;
        fi;

        # Print(products);

        for P in products do
            Print(Concatenation(P[1], ":\n"));

            Print(P[2]);
            Print("\n");
        od;

        if writeoutput then
            name := generate_name(I);

            for P in products do
                CommGridRepnToJsonFile(P[2], JoinStringsWithSeparator([name, "_", P[1],".json"],""));
            od;
        fi;
    od;
od;




