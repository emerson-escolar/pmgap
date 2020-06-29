# Copied from gyoza:
# https://bitbucket.org/remere/gyoza/src/master/
# GPL3
# Then, modified.


CreateObviousIndecMatrices := function(dimv, arrows)
    local  dim, N, matrices, i;
    for dim in dimv do
        if not (dim = 0 or dim = 1) then
            return fail;
        fi;
    od;
    N := Length(arrows);
    matrices := [];
    N := Length(arrows);
    for i in [1..N] do
        if (dimv[arrows[i][1]] = 1 and dimv[arrows[i][2]] = 1) then
            Add(matrices, [String(arrows[i][3]), Z(2)*[[1]]]);
        fi;
        # Add(matrices, [arrows[i][3], NullMat(dimv[arrows[i][1]], dimv[arrows[i][2]], Z(2))+1 ]);
    od;
    return matrices;
end;




CreateLinearQuiverIndecs := function(A)
    local  Q, verts, N, shift_list, M, arrows, arr, src, trgt,
           indecs_list, b, d, dimv, mats;
    # checks that A is actually algebra GF(2) A_n
    Q := QuiverOfPathAlgebra(A);
    verts := VerticesOfQuiver(Q);
    N := Length(verts);

    if not NumberOfArrows(Q) = N-1 then
        return fail;
    fi;

    shift_list := [2..N];
    Add(shift_list, 1);
    M := PermutationMat(PermList(shift_list), N);
    M[N][1] := 0;
    if not M = AdjacencyMatrixOfQuiver(Q) then
        return fail;
    fi;

    if not OriginalPathAlgebra(A) = A then
        return fail;
    fi;

    arrows := [];
    for arr in ArrowsOfQuiver(Q) do
        src := Position(verts, SourceVertex(arr));
        trgt := Position(verts, TargetVertex(arr));
        Add(arrows, [src,trgt, arr]);
    od;

    indecs_list := [];
    for b in [1..N] do
        #simple module at b.. skipped
        for d in [b+1..N] do
            dimv := ListWithIdenticalEntries(N,0);
            dimv{[b..d]} := ListWithIdenticalEntries(d-b+1,1);
            mats := CreateObviousIndecMatrices(dimv ,arrows);
            Add(indecs_list, RightModuleOverPathAlgebra(A, dimv, mats));
        od;
    od;
    Append(indecs_list, SimpleModules(A));
    return indecs_list;
end;

CreateIntervalDimVecs := function(n_rows, n_cols)
    local interval_dimvecs;
    interval_dimvecs := [];
    for start_row in [1..n_rows] do
        for end_col in [1..n_cols] do
            Append(interval_dimvecs, CreateIntervalDimVecsPointed(n_rows, n_cols,
                                                                  start_row, end_col));
        od;
    od;
    return interval_dimvecs;
end;

PrettyPrintDimVec := function(dim_vec, n_cols)
    local counter, d;
    counter := 0;
    Print("Interval\n");
    for d in dim_vec do
        Print(d);
        counter := counter + 1;
        if counter mod n_cols = 0 then
            Print("\n");
        fi;
    od;
    Print("--------\n");
end;
     

LastBirthDeath := function(partial_dim_vec, n_cols)
    local cur_row;
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



CreateIntervalDimVecsPointed := function(n_rows, n_cols, start_row, end_col)
    local graded_intervals, dimvec, intervals,
          b, d, x, height, max_height, bd;

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
            bd := LastBirthDeath(old_int, n_cols);
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



CreateCommutativeGridIntervals := function(A, F, n_rows, n_cols)
    # Trust that A was obtained by
    # A := CreateCommutativeGrid(F, n_rows, n_cols);
    # is there a way to check this?
    local Q, verts, arrows, arr, src, trgt,
          interval_dimvecs, intervals_list, dimv, mats;

    Q := QuiverOfPathAlgebra(A);
    verts := VerticesOfQuiver(Q);
    arrows := [];
    for arr in ArrowsOfQuiver(Q) do
        src := Position(verts, SourceVertex(arr));
        trgt := Position(verts, TargetVertex(arr));
        Add(arrows, [src,trgt, arr]);
    od;

    interval_dimvecs := CreateIntervalDimVecs(n_rows, n_cols);

    intervals_list := [];
    for dimv in interval_dimvecs do
        mats := CreateObviousIndecMatrices(dimv, arrows);
        Add(intervals_list, RightModuleOverPathAlgebra(A, dimv, mats));
    od;

    return intervals_list;
end;
