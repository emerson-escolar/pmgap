# force gap to quit with error state on error.
OnBreak := function()
    Where();
    QUIT_GAP(1);
end;;

LoadPackage("pmgap");
Read("timer.g");

RandomCommGridRepn_Method := RandomCommGridRepn;

time_all := function(nn_list, dd_list)
    local A, V, ans,
          __func_algebra, __func_pm, __func_approx,
          t_alg, t_pm, t_ap,
          nn,dd;

    A := 0;
    V := 0;

    __func_algebra := function(n)
        A := CommGridPathAlgebra(GF(2),2, nn);
        IntervalRepns(A);
    end;

    __func_pm := function(n)
        local j;
        for j in [1..n] do
            V := RandomCommGridRepn_Method(ListWithIdenticalEntries(2 * nn, dd), A);
        od;
    end;

    __func_approx := function(n)
        local j;
        for j in [1..n] do
            IntervalApproximation(V);
        od;
    end;

    ans := [];

    Display("n, d, pathalg_avetime(ms), random_pm_avetime(ms), intapprox_avetime(ms)");
    for nn in nn_list do
        t_alg := timer(__func_algebra);
        for dd in dd_list do
            t_pm := timer(__func_pm);
            t_ap := timer(__func_approx);

            Add(ans, [nn, dd, (1.* t_alg[1])/t_alg[2],
                      (1.* t_pm[1])/t_pm[2],
                      (1.* t_ap[1])/t_ap[2]]);
            Display(JoinStringsWithSeparator(ans[Length(ans)]));
        od;
    od;

    return ans;
end;

# ONEREP
ONEREP := true;
if ONEREP = true then
    TIMER_MIN_RUNTIME_MS := 0;
    time_all([4,8,16],[100,200,400,800]);
fi;



QUIT_GAP(0);
