

InstallGlobalFunction(JsonFileToCommGridRepn,
  function(fname)
      return JsonToCommGridRepn(InputTextFile(fname));
  end);

__JsonToCommGridRepn := function(stream)
    local data, is_left_matrices,
          F, Q, A,
          dim_vec, vert,
          mats, arr, s, st, dim_s, dim_t,
          V;

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

    V := CommGridRepnArrLbl(A, dim_vec, mats);
    return V;
end;

InstallGlobalFunction(JsonToCommGridRepn,
                      __JsonToCommGridRepn);


InstallMethod(CommGridRepnArrLbl,
              "for comm_grid, dim_vec, and matrices",
              ReturnTrue,
              [IsCommGridPathAlgebra, IsList, IsList],
              function(A, dimv, mats)
                  local V;
                  V := RightModuleOverPathAlgebra(A,dimv,mats);
                  SetFilterObj(V, IsCommGridRepn);
                  return V;
              end);


InstallOtherMethod(CommGridRepnArrLbl,
              "for comm_grid and matrices",
              ReturnTrue,
              [IsCommGridPathAlgebra, IsCollection],
              function(A, mats)
                  local V;
                  V := RightModuleOverPathAlgebra(A,mats);
                  SetFilterObj(V, IsCommGridRepn);
                  return V;
              end);


__SourceTargetToArrow := function(Q, s, t)
    local out_arrs, arr;
    out_arrs := OutgoingArrowsOfVertex(Q.(s));
    arr := First(out_arrs, x -> (TargetVertex(x) = Q.(t)));
    return arr;
end;

__TranslateMats := function(A, mats)
    local Q, ans, arr, entry;
    ans := [];
    Q := QuiverOfPathAlgebra(A);
    for entry in mats do
        arr := __SourceTargetToArrow(Q, entry[1], entry[2]);
        if arr = fail then return fail; fi;
        Add(ans, [String(arr), entry[3]]);
    od;
    return ans;
end;


InstallMethod(CommGridRepn,
              "for comm_grid, dim_vec, and matrices",
              ReturnTrue,
              [IsCommGridPathAlgebra, IsList, IsList],
              function(A, dimv, mats)
                  return CommGridRepnArrLbl(A, dimv, __TranslateMats(A,mats));
              end);


InstallOtherMethod(CommGridRepn,
              "for comm_grid and matrices",
              ReturnTrue,
              [IsCommGridPathAlgebra, IsCollection],
              function(A, mats)

                  return CommGridRepnArrLbl(A, __TranslateMats(A,mats));
              end);
