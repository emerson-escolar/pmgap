



InstallGlobalFunction(JsonFileToCommGridRepn,
  function(fname)
      return JsonToCommGridRepn(InputTextFile(fname));
  end);

__JsonToCommGridRepn := function(stream)
    local data, is_left_matrices,
          F, Q, A,
          dim_vec, vert,
          mats, arr, s, st, dim_s, dim_t;

    data := JsonStreamToGap(stream);
    if not IsBound(data.field) or data.field = "rationals" then
        F := Rationals;
    elif not Int(data.field) = fail then
        F := GF(Int(data.field));
    fi;


    if not IsBound(data.is_left_matrices) or
           data.is_left_matrices = true then
        is_left_matrices := true;
    else
        is_left_matrices := false;
    fi;

    A := CommGridPathAlgebra(F, data.rows, data.cols);
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
            continue;
        fi;

        if is_left_matrices = true then
            Add(mats, [String(arr),
                       Identity(F) * TransposedMat(data.matrices.(st))]);
        else
            Add(mats, [String(arr),
                       Identity(F) * (data.matrices.(st))]);
        fi;
    od;

    return [A, RightModuleOverPathAlgebra(A, dim_vec, mats)];
end;

InstallGlobalFunction(JsonToCommGridRepn,
                      __JsonToCommGridRepn);
