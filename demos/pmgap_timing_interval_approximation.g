# force gap to quit with error state on error.
OnBreak := function()
    Where();
    QUIT_GAP(1);
end;;

LoadPackage("pmgap");
Read("timer.g");




avetime_interval_approx := function(A, d, reps)
    local rows, cols,
          i,V,t,
          __func;
    rows := NumCommGridRows(A);
    cols := NumCommGridColumns(A);

    __func := function(n)
        local j;
        for j in [1..n] do
            IntervalApproximation(V);
        od;
    end;

    t := 0;
    for i in [1..reps] do
        V := RandomCommGridRepn(ListWithIdenticalEntries(rows*cols, d), A);
        t := t + timer( __func);
    od;

    return t/reps;
end;

ans := [];

for nn in [2..3] do
    A := CommGridPathAlgebra(GF(2),2, nn);
    for dd in [1..2] do
        ddd := 50 * dd;
        Add(ans, [nn, ddd, avetime_interval_approx(A, 200,10)]);
    od;
od;
Display(ans);

QUIT_GAP(0);
