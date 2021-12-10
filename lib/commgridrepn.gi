
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


__IntFFEMat := function(M)
    local ans, i, j;
    ans := NullMat(DimensionsMat(M)[1],DimensionsMat(M)[2]);
    for i in [1..DimensionsMat(M)[1]] do
        for j in [1..DimensionsMat(M)[2]] do
            ans[i][j] := IntFFE(M[i][j]);
        od;
    od;
    return ans;
end;


__CommGridRepnToJson := function(V, stream)
    local ans, F, A, verts, dim_rec, i, arrs, mats, mat_rec, s, st;

    ans := rec();
    ans.is_left_matrices := false;
    F := LeftActingDomain(V);
    if F = Rationals then
        ans.field := "rationals";
    elif IsField(F) and IsFinite(F) then
        ans.field := Size(F);
    else
        # Unrecognized field!
        return fail;
    fi;

    A := RightActingAlgebra(V);
    ans.rows := NumCommGridRows(A);
    ans.cols := NumCommGridColumns(A);

    # generate dimvec
    verts := VerticesOfQuiver(QuiverOfPathAlgebra(A));
    dim_rec := rec();
    for i in [1..Length(verts)] do
        dim_rec.(String(verts[i])) := DimensionVector(V)[i];
    od;
    ans.dimensions := dim_rec;


    arrs := ArrowsOfQuiver(QuiverOfPathAlgebra(A));
    mats := MatricesOfPathAlgebraModule(V);
    mat_rec := rec();
    for i in [1..Length(arrs)] do
        if dim_rec.(String(SourceVertex(arrs[i]))) = 0 or dim_rec.(String(TargetVertex(arrs[i]))) = 0 then
            continue;
        fi;

        s := Concatenation(String(SourceVertex(arrs[i])),"_");
        st := Concatenation(s, String(TargetVertex(arrs[i])));

        if F = Rationals then
            mat_rec.(st) := mats[i];
        else
            mat_rec.(st) := __IntFFEMat(mats[i]);
        fi;
    od;
    ans.matrices := mat_rec;

    GapToJsonStream(stream, ans);

    return true;
end;


InstallMethod(CommGridRepnToJson,
              "for CommGridRepn and OutputTextStream",
              ReturnTrue,
              [IsCommGridRepn, IsOutputTextStream],
              __CommGridRepnToJson);

InstallMethod(CommGridRepnToJsonFile,
              "for CommGridRepn and filename",
              ReturnTrue,
              [IsCommGridRepn, IsString],
              function(V, fname)
                  local stream, stat;
                  stream := OutputTextFile(fname, false);
                  stat := CommGridRepnToJson(V, stream);
                  CloseStream(stream);
                  return stat;
              end);


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
                  local stream, V;
                  stream := InputTextFile(fname);
                  V := JsonToCommGridRepn(stream);
                  CloseStream(stream);
                  return V;
              end);

InstallOtherMethod(JsonFileToCommGridRepn,
                   "for filename string and comm_grid",
                   ReturnTrue,
                   [IsString, IsCommGridPathAlgebra],
                   function(fname,A)
                       local stream, V;
                       stream := InputTextFile(fname);
                       V := JsonToCommGridRepn(stream,A);
                       CloseStream(stream);
                       return V;
                   end);


InstallMethod(JsonFilesToCommGridRepn,
              "for list of filenames",
              ReturnTrue,
              [IsList],
              function(list_f)
                  local fname, ans, A, i, stream;
                  if Length(list_f) = 0 then
                      return [];
                  fi;
                  stream := InputTextFile(list_f[1]);
                  ans := [JsonToCommGridRepn(stream)];
                  CloseStream(stream);
                  A := RightActingAlgebra(ans[1]);
                  for i in [2..Length(list_f)] do
                      stream := InputTextFile(list_f[i]);
                      Add(ans, JsonToCommGridRepn(stream, A));
                      CloseStream(stream);
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



__RandomCommGridRepn := function(dimv, A, random_mat_func...)
    local RandomMatFunc, n_rows, n_cols, dv, F,
          mats, mats_dict,
          i, j,
          __LookupVertexDimension, __UpdateMatsAndDict,
          vd_0_0,vd_1_0,vd_0_1,vd_1_1,
          mat_vert, mat_hori, K, premult,
          A_vert, A_hori, pb, dim_pb,  V;

    if 0 = Length(random_mat_func) then
        RandomMatFunc := RandomMatRandomRank;
    else
        RandomMatFunc := random_mat_func[1];
    fi;

    n_rows := NumCommGridRows(A);
    n_cols := NumCommGridColumns(A);
    dv := CommGridRowColumnToVertexDict(A);
    F := LeftActingDomain(A);
    mats := [];
    mats_dict := NewDictionary(["1_1","2_2", "h"], true);

    __LookupVertexDimension := function(i,j)
        local vert, dim;
        vert := String(LookupDictionary(dv, [i, j]));
        dim := dimv[(i-1)*n_cols + j];
        return rec(v := vert, d := dim);
    end;

    __UpdateMatsAndDict := function(v1,v2,mat)
        Add(mats, [v1, v2, mat]);
        AddDictionary(mats_dict, [v1, v2], Length(mats));
        return true;
    end;

    # generate last line of matrices
    for j in [1..n_cols-1] do
        vd_0_0 := __LookupVertexDimension(n_rows, j);
        vd_0_1 := __LookupVertexDimension(n_rows, j+1);

        if vd_0_0.d <> 0 and vd_0_1.d <> 0 then
            __UpdateMatsAndDict(vd_0_0.v, vd_0_1.v, RandomMatFunc(vd_0_0.d, vd_0_1.d, F));
        fi;
    od;
    for i in [(n_rows-1),(n_rows-2)..1] do
        # generate vertical arrow on last column
        vd_0_0 := __LookupVertexDimension(i, n_cols);
        vd_1_0 := __LookupVertexDimension(i+1, n_cols);

        if vd_0_0.d <> 0 and vd_1_0.d <> 0 then
            __UpdateMatsAndDict(vd_0_0.v, vd_1_0.v, RandomMatFunc(vd_0_0.d, vd_1_0.d, F));
        fi;

        for j in [(n_cols-1),(n_cols-2)..1] do
            vd_0_0 := __LookupVertexDimension(i, j);
            vd_1_0 := __LookupVertexDimension(i+1, j);
            vd_0_1 := __LookupVertexDimension(i, j+1);
            vd_1_1 := __LookupVertexDimension(i+1, j+1);

            if vd_0_0.d = 0 then
                continue;
            fi;
            if vd_1_1.d = 0 then
                # anything will do
                if vd_1_0.d <> 0 then
                    mat_vert := RandomMatFunc(vd_0_0.d, vd_1_0.d, F);
                    __UpdateMatsAndDict(vd_0_0.v, vd_1_0.v, mat_vert);
                fi;
                if vd_0_1.d <> 0 then
                    mat_hori := RandomMatFunc(vd_0_0.d, vd_0_1.d, F);
                    __UpdateMatsAndDict(vd_0_0.v, vd_0_1.v, mat_hori);
                fi;
                continue;
            fi;

            if vd_1_0.d <> 0 and vd_0_1.d = 0 then
                A_hori := mats[LookupDictionary(mats_dict, [vd_1_0.v, vd_1_1.v])][3];
                K := NullspaceMat(A_hori);
                if Length(K) = 0 then
                    mat_vert := NullMat(vd_0_0.d, vd_1_0.d, F);
                else
                    mat_vert := RandomMatFunc(vd_0_0.d, DimensionsMat(K)[1], F) * K;
                fi;
                __UpdateMatsAndDict(vd_0_0.v, vd_1_0.v, mat_vert);
                continue;
            fi;

            if vd_0_1.d <> 0 and vd_1_0.d = 0 then
                A_vert := mats[LookupDictionary(mats_dict, [vd_0_1.v, vd_1_1.v])][3];
                K := NullspaceMat(A_vert);
                if Length(K) = 0 then
                    mat_hori := NullMat(vd_0_0.d, vd_0_1.d, F);
                else
                    mat_hori := RandomMatFunc(vd_0_0.d, DimensionsMat(K)[1], F) * K;
                fi;
                __UpdateMatsAndDict(vd_0_0.v, vd_0_1.v, mat_hori);
                continue;
            fi;

            A_hori := mats[LookupDictionary(mats_dict, [vd_1_0.v, vd_1_1.v])][3];
            A_vert := mats[LookupDictionary(mats_dict, [vd_0_1.v, vd_1_1.v])][3];

            pb := PullbackMatrices(A_hori, A_vert);

            if pb = fail then
                # zero pullback
                mat_vert := NullMat(vd_0_0.d, vd_1_0.d, F);
                __UpdateMatsAndDict(vd_0_0.v, vd_1_0.v, mat_vert);
                mat_hori := NullMat(vd_0_0.d, vd_0_1.d, F);
                __UpdateMatsAndDict(vd_0_0.v, vd_0_1.v, mat_hori);
                continue;
            fi;

            dim_pb := DimensionsMat(pb[1]);
            premult := RandomMatFunc(vd_0_0.d, dim_pb[2], F);
            mat_vert := premult * pb[1];
            mat_hori := premult * pb[2];

            Add(mats, [vd_0_0.v, vd_1_0.v, mat_vert]);
            AddDictionary(mats_dict, [vd_0_0.v, vd_1_0.v], Length(mats));

            Add(mats, [vd_0_0.v, vd_0_1.v, mat_hori]);
            AddDictionary(mats_dict, [vd_0_0.v, vd_0_1.v], Length(mats));
        od;
    od;

    V := CommGridRepn(A,dimv, mats);
    return V;
end;



InstallMethod(RandomCommGridRepnRandomRanks,
              "for dim_vec, A",
              ReturnTrue,
              [IsList, IsCommGridPathAlgebra],
              __RandomCommGridRepn);


InstallMethod(RandomCommGridRepn,
              "for dim_vec, A",
              ReturnTrue,
              [IsList, IsCommGridPathAlgebra],
              function(dim_vec, A)
                  return __RandomCommGridRepn(dim_vec, A, RandomMat);
              end);



InstallGlobalFunction(JordanCellLadder,
                     function(F, d, lambda)
                         local A, mats, J, II, IJ, i;
                         A := CommGridPathAlgebra(F, 2, 5);

                         J := IdentityMat(d,F) * lambda;
                         for i in [1..d-1] do
                             J[i+1][i] := Identity(F);
                         od;

                         II := StackMatricesHorizontalCopy(IdentityMat(d,F), IdentityMat(d,F));
                         IJ := StackMatricesHorizontalCopy(IdentityMat(d,F), J);

                         mats := [["1_2", "1_3", StackMatricesHorizontalCopy(NullMat(d,d,F),IdentityMat(d,F))],
                                  ["1_3", "1_4", IdentityMat(2*d,F)],
                                  ["1_4", "1_5", StackMatricesVerticalCopy(NullMat(d,d,F),IdentityMat(d,F))],
                                  ["2_1", "2_2", StackMatricesHorizontalCopy(IdentityMat(d,F),NullMat(d,d,F))],
                                  ["2_2", "2_3", IdentityMat(2*d,F)],
                                  ["2_3", "2_4", StackMatricesVerticalCopy(IdentityMat(d,F),NullMat(d,d,F))],
                                  ["1_2", "2_2", IJ],
                                  ["1_3", "2_3", StackMatricesVerticalCopy(II, IJ)],
                                  ["1_4", "2_4", TransposedMat(II)]];

                         return CommGridRepn(A, [0,d,2*d,2*d,d,d,2*d,2*d,d,0], mats);
                     end);


InstallGlobalFunction(JordanCellThreeByThree,
                     function(F, d, lambda)
                         local A, mats, J, II, IJ, i;
                         A := CommGridPathAlgebra(F, 3, 3);

                         J := IdentityMat(d,F) * lambda;
                         for i in [1..d-1] do
                             J[i+1][i] := Identity(F);
                         od;

                         II := StackMatricesHorizontalCopy(IdentityMat(d,F), IdentityMat(d,F));
                         IJ := StackMatricesHorizontalCopy(IdentityMat(d,F), J);

                         mats := [["1_2", "1_3", J],
                                  ["2_1", "2_2", II],
                                  ["2_2", "2_3", StackMatricesVerticalCopy(NullMat(d,d,F),IdentityMat(d,F))],
                                  ["3_1", "3_2", IdentityMat(d,F)],
                                  ["2_1", "3_1", IdentityMat(d,F)],
                                  ["1_2", "2_2", IJ],
                                  ["2_2", "3_2", StackMatricesVerticalCopy(IdentityMat(d,F),NullMat(d,d,F))],
                                  ["1_3", "2_3", IdentityMat(d,F)]];

                         return CommGridRepn(A, [0,d,d, d,2*d,d, d,d,0], mats);
                     end);



# ****************************** Functions below are for IndecWithLineRestriction ******************************

__CheckIntervalList := function(listV)
    return true;
end;


__SeparateAndShift := function(listV)
    local ans, used_deaths, find_next_unused_greater_than, pair, dprime, ell;

    find_next_unused_greater_than := function(x)
        local xf;
        xf := x;
        repeat
            xf := xf + 1;
        until not (xf in used_deaths);

        return xf;
    end;

    ans := [];

    # separate
    used_deaths := Set([]);
    for pair in listV do
        if not (pair[2] in used_deaths) then
            Add(ans, pair);
            AddSet(used_deaths, pair[2]);
        else
            dprime := find_next_unused_greater_than(pair[2]);
            Add(ans, [pair[1], dprime]);
            AddSet(used_deaths, dprime);
        fi;
    od;

    # shift, improved shift parameter ell
    ell := Maximum(List(ans, pair->pair[1]+pair[2])) - 2 * used_deaths[1];

    return List(ans, pair->[pair[1], pair[2]+ell]);
end;

InstallGlobalFunction(SeparateAndShift,
                      __SeparateAndShift);


__Verticalize := function(listV)
    local twomu;

    twomu := Maximum(List(listV, pair->(pair[1]+pair[2])));
    return List(listV, pair->[twomu - pair[2], pair[2]]);
end;

__hasonedimvs := function(pair, idx)
    return pair[1] <= idx and idx <= pair[2];
end;

__GenerateMatricesAlongRow := function(F, listV, rownum)
    local mats, n, mincol, maxcol,
          curcol, idx, jdx, mat;

    mats := [];
    n := Length(listV);

    mincol := Minimum(List(listV, pair->pair[1]));
    maxcol := Maximum(List(listV, pair->pair[2]));

    if mincol < 1 then
        mincol := 1;
    fi;

    for curcol in [mincol..maxcol-1] do
        mat := [1..n];
        for idx in [1..n] do
            if __hasonedimvs(listV[idx], curcol) then
                mat[idx] := [1..n];
                for jdx in [1..n] do
                    if __hasonedimvs(listV[jdx], curcol+1) then
                        if idx = jdx then
                            mat[idx][jdx] := 1;
                        else
                            mat[idx][jdx] := 0;
                        fi;
                    else
                        Unbind\[\](mat[idx], jdx);
                    fi;
                od;
            else
                Unbind\[\](mat, idx);
            fi;
        od;

        mat := Identity(F)*Compacted(List(mat, row->Compacted(row)));
        if IsMatrix(mat) then
            Add(mats, [Concatenation(String(rownum), "_", String(curcol)),
                       Concatenation(String(rownum), "_", String(curcol+1)),
                       mat]);
        fi;
    od;
    # Print(mats);
    # Print("\n");
    return mats;
end;


__GenerateMatricesBetweenRows := function(F, sourceV, targetV, sourcerow)
    local mats, n, mincol, maxcol,
          curcol, idx, jdx, mat;

    mats := [];
    n := Length(sourceV);

    mincol := Minimum(Minimum(List(sourceV, pair->pair[1])), Minimum(List(targetV, pair->pair[1])));
    maxcol := Maximum(Maximum(List(sourceV, pair->pair[2])), Maximum(List(targetV, pair->pair[2])));

    if mincol < 1 then
        mincol := 1;
    fi;

    for curcol in [mincol..maxcol] do
        mat := [1..n];
        for idx in [1..n] do
            if __hasonedimvs(sourceV[idx], curcol) then
                mat[idx] := [1..n];
                for jdx in [1..n] do
                    if __hasonedimvs(targetV[jdx], curcol) then
                        if idx = jdx then
                            mat[idx][jdx] := 1;
                        else
                            mat[idx][jdx] := 0;
                        fi;
                    else
                        Unbind\[\](mat[idx], jdx);
                    fi;
                od;
            else
                Unbind\[\](mat, idx);
            fi;
        od;
        mat := Identity(F)*Compacted(List(mat, row->Compacted(row)));
        if IsMatrix(mat) then
            Add(mats, [Concatenation(String(sourcerow), "_", String(curcol)),
                       Concatenation(String(sourcerow+1), "_", String(curcol)),
                       mat]);
        fi;
    od;
    # Print(mats);
    # Print("\n");
    return mats;
end;

__GenerateDiagonalMatrixFromConeTip := function(F, coneTip, targetV, sourcerow)
    local mats, n,
          curcol, jdx, mat;

    mats := [];
    n := Length(targetV);

    for curcol in [coneTip[1]..coneTip[2]] do
        mat := [[1..n]];
        for jdx in [1..n] do
            if __hasonedimvs(targetV[jdx], curcol) then
                    mat[1][jdx] := 1;
            else
                Unbind\[\](mat[1], jdx);
            fi;
        od;

        mat := Identity(F)*Compacted(List(mat, row->Compacted(row)));
        if IsMatrix(mat) then
            Add(mats, [Concatenation(String(sourcerow), "_", String(curcol)),
                       Concatenation(String(sourcerow+1), "_", String(curcol)),
                       mat]);
        fi;
    od;
    # Print(mats);
    # Print("\n");
    return mats;
end;


__IndecWithLineRestriction := function(F, listV)
    local SepShift, Vert, ConeTip, Cone, n, i, j,
          w, A,
          mats, dimvec;

    n := Length(listV);
    SepShift := SeparateAndShift(listV);
    Vert := __Verticalize(SepShift);
    ConeTip := [Maximum(List(Vert, pair->pair[1])), Maximum(List(Vert, pair->pair[2]))];
    Cone := [ConeTip];
    for i in [1..n-1] do
        Add(Cone,[0,0]);
    od;

    w := Maximum(List(SepShift, pair->pair[2]));
    A := CommGridPathAlgebra(F, 4, w);

    mats := [];
    Append(mats, __GenerateMatricesAlongRow(F, listV, 4));
    Append(mats, __GenerateMatricesAlongRow(F, SepShift, 3));
    Append(mats, __GenerateMatricesAlongRow(F, Vert, 2));
    Append(mats, __GenerateMatricesAlongRow(F, Cone, 1));
    Append(mats, __GenerateMatricesBetweenRows(F, SepShift, listV, 3));
    Append(mats, __GenerateMatricesBetweenRows(F, Vert, SepShift, 2));
    Append(mats, __GenerateDiagonalMatrixFromConeTip(F, ConeTip, Vert, 1));
    # Print(mats);

    dimvec := Concatenation(List([1..w], h->Number(Cone, pair->__hasonedimvs(pair, h))),
                            List([1..w], h->Number(Vert, pair->__hasonedimvs(pair, h))),
                            List([1..w], h->Number(SepShift, pair->__hasonedimvs(pair, h))),
                            List([1..w], h->Number(listV, pair->__hasonedimvs(pair, h))));
    # Print("\nInferredDimvec: ");
    # Print(dimvec);
    # Print("\n");

    return CommGridRepn(A, dimvec, mats);
end;


InstallGlobalFunction(IndecWithLineRestriction,
                      __IndecWithLineRestriction);


# ****************************** Functions above are for IndecWithLineRestriction ******************************
