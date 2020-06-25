



EquiorientedAnPathAlgebra := function(F, n)
    local Q;
    Q := DynkinQuiver("A",n,ListWithIdenticalEntries(n-1,"r"));
    return PathAlgebra(F, Q);
end;


CreateCommutativeGrid := function(F, n_rows, n_cols)
    local Ar, Ac, A;;
    Ar := EquiorientedAnPathAlgebra(F, n_rows);
    Ac := EquiorientedAnPathAlgebra(F, n_cols);
    A := TensorProductOfAlgebras(Ar, Ac);
    return A;
end;

ReadRepnL := function(F, fname)
    return ReadRepn(F, fname, true);
end;

ReadRepnR := function(F, fname)
    return ReadRepn(F, fname, false);
end;

ReadRepn := function(F, fname, is_left_matrices)
    local data,
          Q, A,
          dim_vec, vert,
          mats, arr, s, st, dim_s, dim_t;

    data := JsonStreamToGap(InputTextFile(fname));

    A := CreateCommutativeGrid(F, data.rows, data.cols);
    Q := QuiverOfPathAlgebra(A);

    dim_vec := [];
    for vert in VerticesOfQuiver(Q) do
        if not IsBound(data.dimensions.(String(vert))) then
            Add(dim_vec, 0);
        else
            Add(dim_vec, data.dimensions.(String(vert)));
        fi;
    od;

    mats := [];
    for arr in ArrowsOfQuiver(Q) do
        s := Concatenation(String(SourceVertex(arr)), "_");
        st := Concatenation(s, String(TargetVertex(arr)));
        if not IsBound(data.matrices.(st)) then
            # dim_s := dim_vec[Position(VerticesOfQuiver(Q),
            #                           SourceVertex(arr))];
            # dim_t := dim_vec[Position(VerticesOfQuiver(Q),
            #                           TargetVertex(arr))];
        else
            if is_left_matrices = true then
                Add(mats, [String(arr),
                           Identity(F) * TransposedMat(data.matrices.(st))]);
            else
                Add(mats, [String(arr),
                           Identity(F) * TransposedMat(data.matrices.(st))]);
            fi;
        fi;
    od;
    return [A, RightModuleOverPathAlgebra(A, dim_vec, mats)];
end;
