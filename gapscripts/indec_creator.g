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
    interval_dimvecs := [];
    # TODO: generate this

    return interval_dimvecs;
end;


CreateCommutativeGridIntervals := function(A, F, n_rows, n_cols)
    # Trust that A was obtained by
    # A := CreateCommutativeGrid(F, n_rows, n_cols);
    # is there a way to check this?

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
    for dimv in obvious_dimvecs do
        mats := CreateObviousIndecMatrices(dimv, arrows);
        Add(intervals_list, RightModuleOverPathAlgebra(A, dimv, mats));
    od;

    return intervals_list;
end;
