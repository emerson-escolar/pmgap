# force gap to quit with error state on error.
OnBreak := function()
    Where();
    QUIT_GAP(1);
end;;

LoadPackage("pmgap");
Read("timer.g");


time_all := function(nn, d)
    local A, V,
          __func_algebra, __func_pm, __func_approx;

    A := 0;
    V := 0;

    __func_algebra := function(n)
        A := CommGridPathAlgebra(GF(2),2, nn);
        IntervalRepns(A);
    end;

    __func_pm := function(n)
        local j;
        for j in [1..n] do
            V := RandomCommGridRepn(ListWithIdenticalEntries(2 * nn, d), A);
        od;
    end;

    __func_approx := function(n)
        local j;
        for j in [1..n] do
            IntervalApproximation(V);
        od;
    end;

    return [timer(__func_algebra), timer(__func_pm), timer(__func_approx)];
end;

ans := [];


# ONEREP
ONEREP := true;
if ONEREP = true then
    Display("****************************************\n");
    TIMER_MIN_RUNTIME_MS := 0;
    for nn in [4,8,16] do
        for dd in [100,200,400,800] do
            result := time_all(nn, dd);
            Add(ans, [nn, dd, (1.* result[1][1])/result[1][2],
                      (1.* result[2][1])/result[2][2],
                      (1.* result[3][1])/result[3][2]]);
            Display(ans[Length(ans)]);
        od;
    od;
    Display("****************************************\n\n");
fi;






QUIT_GAP(0);
