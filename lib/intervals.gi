




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



__CreateCommutativeGridIntervalDimVecsPointed := function(n_rows, n_cols, start_row, end_col)
    local graded_intervals, dimvec, intervals,
          b, d, x, height, max_height, bd, old_int, interval_list;

    graded_intervals := [[]];
    dimvec := ListWithIdenticalEntries(n_rows*(start_row-1), 0);

    # Generate height 1 graded_intervals
    for b in [1..end_col] do
        x := Concatenation(dimvec, ListWithIdenticalEntries(b-1, 0));
        Append(x, ListWithIdenticalEntries(end_col-b+1, 1));
        Append(x, ListWithIdenticalEntries(n_cols - end_col, 0));
        Add(graded_intervals[1], x);
    od;

    max_height := n_rows-start_row + 1;
    for height in [2..max_height] do
        Add(graded_intervals, []);

        for old_int in graded_intervals[height-1] do
            bd := __LastBirthDeath(old_int, n_cols);
            # Generate next-height graded_intervals
            for b in [1..bd[1]] do
                for d in [bd[1]..bd[2]] do
                    x := Concatenation(old_int, ListWithIdenticalEntries(b-1, 0));
                    Append(x, ListWithIdenticalEntries(d-b+1, 1));
                    Append(x, ListWithIdenticalEntries(n_cols-d, 0));
                    Add(graded_intervals[height], x);
                od;
            od;
            # finish up previous-height graded_intervals
            Append(old_int, ListWithIdenticalEntries(n_rows*n_cols - Length(old_int), 0));
        od;
    od;

    # finish up previous-height graded_intervals
    for old_int in graded_intervals[max_height] do
        Append(old_int, ListWithIdenticalEntries(n_rows*n_cols - Length(old_int), 0));
    od;

    intervals := [];
    for interval_list in graded_intervals do
        Append(intervals, interval_list);
    od;

    return intervals;
end;


__CreateCommutativeGridIntervalDimVecs := function(n_rows, n_cols)
    local interval_dimvecs, start_row, end_col;
    interval_dimvecs := [];
    for start_row in [1..n_rows] do
        for end_col in [1..n_cols] do
            Append(interval_dimvecs, __CreateCommutativeGridIntervalDimVecsPointed(n_rows, n_cols,
                                                                                 start_row, end_col));
        od;
    od;
    return interval_dimvecs;
end;


InstallMethod(IntervalDimVecs,
              "for a commutative grid path algebra",
              ReturnTrue,
              [IsCommGridPathAlgebra],
              function(A)
                  return __CreateCommutativeGridIntervalDimVecs(NumCommGridRows(A), NumCommGridColumns(A));
              end);
