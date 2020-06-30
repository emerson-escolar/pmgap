LoadPackage("json");
LoadPackage("qpa");


CreateCommutativeGridPosetAlgebra := function(F, n_rows, n_cols)

end;


ReadCommutativeGridRepn := function(F, fname, is_left_matrices)
    local data,
          Q, A,
          dim_vec, vert,
          mats, arr, s, st, dim_s, dim_t;

    data := JsonStreamToGap(InputTextFile(fname));

    A := CreateCommutativeGridPathAlgebra(F, data.rows, data.cols);
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


ReadCommutativeGridRepnL := function(F, fname)
    return ReadCommutativeGridRepn(F, fname, true);
end;


ReadCommutativeGridRepnR := function(F, fname)
    return ReadCommutativeGridRepn(F, fname, false);
end;
