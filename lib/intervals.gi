




__LastBirthDeath := function(partial_dim_vec, n_cols)
    local cur_row, birth, death;
    cur_row := Int(Ceil(1.*Length(partial_dim_vec)/n_cols));
    birth := PositionProperty(partial_dim_vec, x->x=1, (cur_row-1)*n_cols);
    birth := (birth-1) mod n_cols +1;
    if birth = fail then
        death := fail;
    else
        death := Length(partial_dim_vec) -  PositionProperty(Reversed(partial_dim_vec), x->x=1) + 1;
        death := (death-1) mod n_cols + 1;
    fi;
    return [birth,death];
end;



__CommGridIntervalDimVecsPointed := function(n_rows, n_cols, start_row, end_col)
    local graded_intervals, dimvec,
          b, d, x, height, max_height, bd, old_int;

    graded_intervals := rec( 1 := [] );
    dimvec := ListWithIdenticalEntries(n_cols*(start_row-1), 0);

    # Generate height 1 graded_intervals
    for b in [1..end_col] do
        x := Concatenation(dimvec, ListWithIdenticalEntries(b-1, 0));
        Append(x, ListWithIdenticalEntries(end_col-b+1, 1));
        Append(x, ListWithIdenticalEntries(n_cols - end_col, 0));
        Add(graded_intervals.1, x);
    od;

    max_height := n_rows-start_row + 1;
    for height in [2..max_height] do
        graded_intervals.(height) := [];

        for old_int in graded_intervals.(height-1) do
            bd := __LastBirthDeath(old_int, n_cols);
            # Generate next-height graded_intervals
            for b in [1..bd[1]] do
                for d in [bd[1]..bd[2]] do
                    x := Concatenation(old_int, ListWithIdenticalEntries(b-1, 0));
                    Append(x, ListWithIdenticalEntries(d-b+1, 1));
                    Append(x, ListWithIdenticalEntries(n_cols-d, 0));
                    Add(graded_intervals.(height), x);
                od;
            od;
            # finish up previous-height graded_intervals
            Append(old_int, ListWithIdenticalEntries(n_rows*n_cols - Length(old_int), 0));
        od;
    od;

    # finish up previous-height graded_intervals
    for old_int in graded_intervals.(max_height) do
        Append(old_int, ListWithIdenticalEntries(n_rows*n_cols - Length(old_int), 0));
    od;
    return graded_intervals;
end;

__MergeIntoRecord_Lists := function(target, source)
    local i;
    Print("source", source, "\n");

    for i in RecNames(source) do
        if not IsBound(target.(i)) then
            target.(i) := source.(i);
        else
            Append(target.(i), source.(i));
        fi;
    od;
    Print(target, "\n");

end;

__CommGridIntervalDimVecs := function(n_rows, n_cols)
    local interval_dimvecs, gr, start_row, end_col;
    interval_dimvecs := rec();
    for start_row in [1..n_rows] do
        for end_col in [1..n_cols] do
            gr := __CommGridIntervalDimVecsPointed(n_rows, n_cols, start_row, end_col);
            __MergeIntoRecord_Lists(interval_dimvecs, gr);
        od;
    od;
    return interval_dimvecs;
end;



InstallMethod(IntervalDimVecs,
              "for a commutative grid path algebra",
              ReturnTrue,
              [IsCommGridPathAlgebra],
              function(A)
                  local idv;
                  idv :=__CommGridIntervalDimVecs(NumCommGridRows(A), NumCommGridColumns(A));
                  return idv;
              end);
