
InstallMethod(IsCommGridRepn,
              "for path algebra mat module",
              ReturnTrue,
              [IsPathAlgebraMatModule],
              function(V)
                  local A;
                  A := RightActingAlgebra(V);
                  if "IsCommGridPathAlgebra" in KnownPropertiesOfObject(A) and
                     IsCommGridPathAlgebra(A) = true then
                      return true;
                  else
                      return false;
                  fi;
              end);


InstallMethod(IsEquiorientedAnRepn,
              "for path algebra mat module",
              ReturnTrue,
              [IsPathAlgebraMatModule],
              function(V)
                  local A;
                  A := RightActingAlgebra(V);
                  if "IsEquiorientedAnPathAlgebra" in KnownPropertiesOfObject(A) and
                     IsEquiorientedAnPathAlgebra(A) = true then
                      return true;
                  else
                      return false;
                  fi;
              end);


__CheckOrProduceCGPA :=
function(A, F, n_rows, n_cols)
    if A = false then
        return CommGridPathAlgebra(F, n_rows, n_cols);
    elif IsCommGridPathAlgebra(A) = true and
         NumCommGridRows(A) = n_rows and
         NumCommGridColumns(A) = n_cols and
         LeftActingDomain(A) = F then
        return A;
    fi;
    return fail;
end;



__JsonToCommGridRepn := function(stream, A)
    local data, is_left_matrices,
          F, Q,
          dim_vec, vert,
          mats, arr, s, st, dim_s, dim_t,
          V;

    data := JsonStreamToGap(stream);

    if not IsBound(data.field) or
           data.field = "rationals" then
        F := Rationals;
    elif not Int(data.field) = fail then
        F := GF(Int(data.field));
    fi;
    A := __CheckOrProduceCGPA(A,F,data.rows,data.cols);
    if A = fail then return fail; fi;

    Q := QuiverOfPathAlgebra(A);
    if not IsBound(data.is_left_matrices) or
           data.is_left_matrices = true then
        is_left_matrices := true;
    else
        is_left_matrices := false;
    fi;

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
        if (not IsBound(data.matrices.(st))) or
           data.matrices.(st) = 0 then
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

InstallMethod(JsonToCommGridRepn,
              "for stream",
              ReturnTrue,
              [IsInputTextStream],
              function(stream)
                  return __JsonToCommGridRepn(stream,false);
              end);

InstallOtherMethod(JsonToCommGridRepn,
                   "for stream and comm_grid",
                   ReturnTrue,
                   [IsInputTextStream, IsCommGridPathAlgebra],
                   __JsonToCommGridRepn);

InstallMethod(JsonFileToCommGridRepn,
              "for filename string",
              ReturnTrue,
              [IsString],
              function(fname)
                  return JsonToCommGridRepn(InputTextFile(fname));
              end);

InstallOtherMethod(JsonFileToCommGridRepn,
                   "for filename string and comm_grid",
                   ReturnTrue,
                   [IsString, IsCommGridPathAlgebra],
                   function(fname,A)
                       return JsonToCommGridRepn(InputTextFile(fname),A);
                   end);


InstallMethod(JsonFilesToCommGridRepn,
              "for list of filenames",
              ReturnTrue,
              [IsList],
              function(list_f)
                  local fname, ans, A, i;
                  if Length(list_f) = 0 then return []; fi;
                  ans := [JsonToCommGridRepn(InputTextFile(list_f[1]))];
                  A := RightActingAlgebra(ans[1]);
                  for i in [2..Length(list_f)] do
                      Add(ans, JsonToCommGridRepn(InputTextFile(list_f[i]), A));
                  od;
                  return ans;
              end);


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
    local Q, F, ans, arr, entry;
    ans := [];
    Q := QuiverOfPathAlgebra(A);
    F := LeftActingDomain(A);
    for entry in mats do
        arr := __SourceTargetToArrow(Q, entry[1], entry[2]);
        if arr = fail then return fail; fi;
        Add(ans, [String(arr), Identity(F)*entry[3]]);
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
