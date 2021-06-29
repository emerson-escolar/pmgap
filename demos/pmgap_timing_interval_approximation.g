# force gap to quit with error state on error.
OnBreak := function()
    Where();
    QUIT_GAP(1);
end;;

LoadPackage("pmgap");
Read("timer.g");




avetime_interval_approx := function(A, d, min_reps)
    local rows, cols,
          i,V,t, reps,
          __func, one_res;
    rows := NumCommGridRows(A);
    cols := NumCommGridColumns(A);

    __func := function(n)
        local j;
        for j in [1..n] do
            IntervalApproximation(V);
        od;
    end;

    t := 0;
    reps := 0;
    while reps < min_reps do
        V := RandomCommGridRepn(ListWithIdenticalEntries(rows*cols, d), A);
        one_res := timer( __func);
        t := t + one_res[1];
        reps := reps + one_res[2];
    od;

    return [t, reps];
end;

ans := [];

# MAIN TABLE
MAIN := false;
if MAIN = true then
    TIMER_MIN_RUNTIME_MS := 100;
    Display("****************************************\n");
    for nn in [4,8,16] do
        A := CommGridPathAlgebra(GF(2),2, nn);
        IntervalRepns(A);
        for dd in [100,200,400,800] do
            result := avetime_interval_approx(A, dd, 5);
            Add(ans, [nn, dd, 1. * result[1]/ result[2], us2times(1000 * result[1]/ result[2]), result]);
            Display(ans[Length(ans)]);
        od;
    od;
    Display("****************************************\n\n");
fi;


# ONEREP
ONEREP := true;
if ONEREP = true then
    Display("****************************************\n");
    TIMER_MIN_RUNTIME_MS := 0;
    for nn in [32,64] do
        A := CommGridPathAlgebra(GF(2),2, nn);
        IntervalRepns(A);
        for dd in [100] do
            result := avetime_interval_approx(A, dd, 1);
            Add(ans, [nn, dd, 1. * result[1]/ result[2], us2times(1000 * result[1]/ result[2]), result]);
            Display(ans[Length(ans)]);
        od;
    od;
    for nn in [4] do
        A := CommGridPathAlgebra(GF(2),2, nn);
        IntervalRepns(A);
        for dd in [1600,3200] do
            result := avetime_interval_approx(A, dd, 1);
            Add(ans, [nn, dd, 1. * result[1]/ result[2], us2times(1000 * result[1]/ result[2]), result]);
            Display(ans[Length(ans)]);
        od;
    od;
    Display("****************************************\n\n");
fi;






QUIT_GAP(0);
