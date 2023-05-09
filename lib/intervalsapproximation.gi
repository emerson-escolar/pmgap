



__MatricesOnPaths := function(V)
    local i, A, arrs, dam, da, dv, n_rows, n_cols, pathrec, \
    sr, sc, a_s, a_t, arr, entry, new_entry, done;

    if not IsCommGridRepn(V) then
        return fail;
    fi;

    A := RightActingAlgebra(V);

    arrs := ArrowsOfQuiver(QuiverOfPathAlgebra(A));
    dam := NewDictionary(arrs[1] ,true);
    for i in [1..Length(arrs)] do
        AddDictionary(dam, arrs[i], MatricesOfPathAlgebraModule(V)[i]);
    od;

    da := CommGridSourceTargetToArrowDict(A);
    dv := CommGridRowColumnToVertexDict(A);

    n_rows := NumCommGridRows(A);
    n_cols := NumCommGridColumns(A);

    pathrec := rec(1 := []);
    for sr in [1..n_rows] do
        for sc in [1..n_cols] do
            arr := CommGridRowColumnDirectionToArrow(A, [sr,sc], 'r');
            if not (arr = fail) then
                new_entry := [[sr,sc], [sr+1,sc], LookupDictionary(dam, arr)];
                Add(pathrec.1, new_entry);
            fi;
            arr := CommGridRowColumnDirectionToArrow(A, [sr,sc], 'c');
            if not (arr = fail) then
                new_entry := [[sr,sc], [sr,sc+1], LookupDictionary(dam, arr)];
                Add(pathrec.1, new_entry);
            fi;
        od;
    od;

    for i in [2..n_rows+n_cols-2] do
        pathrec.(i) := [];
        done := [];
        for entry in pathrec.(i-1) do
            if not (String([entry[1], entry[2] + [1,0]]) in done) then
                arr := CommGridRowColumnDirectionToArrow(A, entry[2], 'r');
                if not (arr = fail) then
                    new_entry := [entry[1], entry[2] + [1,0], entry[3] * LookupDictionary(dam, arr)];
                    Add(pathrec.(i), new_entry);
                    AddSet(done, String([new_entry[1], new_entry[2]]));
                fi;
            fi;

            if not (String([entry[1], entry[2] + [0,1]]) in done) then
                arr := CommGridRowColumnDirectionToArrow(A, entry[2], 'c');
                if not (arr = fail) then
                    new_entry := [entry[1], entry[2] + [0,1], entry[3] * LookupDictionary(dam, arr)];
                    Add(pathrec.(i), new_entry);
                    AddSet(done, String([new_entry[1], new_entry[2]]));
                fi;
            fi;
        od;
    od;
    return pathrec;
end;



InstallMethod(MatricesOnPaths,
              "for CommGridRepn",
              ReturnTrue,
              [IsCommGridRepn],
              __MatricesOnPaths);


__Source_Target_To_String_Code := function(s, t)
    return JoinStringsWithSeparator(List([s[1], s[2], t[1], t[2]],x->String(x)),"_");
end;



__CompressedMultiplicity2N := function(V)
    local A, n_rows, n_cols, dv, F,
          dim_vec,
          mats, height, entry, mats_dict,
          ans,
          intervals, I,
          sources, sinks,
          vertex, mult, mat1, mat2, mat3, mat4, r, c;


    if not IsCommGridRepn(V) then
        return fail;
    fi;

    A := RightActingAlgebra(V);
    F := LeftActingDomain(V);
    n_rows := NumCommGridRows(A);
    n_cols := NumCommGridColumns(A);
    dv := CommGridRowColumnToVertexDict(A);

    dim_vec := DimensionVector(V);

    if n_rows <> 2 then
        return fail;
    fi;

    mats := MatricesOnPaths(V);
    # convert mats to usable dictionary format
    mats_dict := NewDictionary("1_1_2_2", true);
    for height in RecNames(mats) do
        for entry in mats.(height) do
            AddDictionary(mats_dict,
                          __Source_Target_To_String_Code(entry[1],entry[2]),
                          entry[3]);
        od;
    od;

    ans := [];

    intervals := IntervalRepns(A);
    for height in RecNames(intervals) do
        for I in intervals.(height) do
            sources := SourceVertices(I);
            sinks := SinkVertices(I);

            mult := 0;

            if (Length(sources) = 1) and (Length(sinks) = 1) then
                if sources[1] = sinks[1] then
                    vertex := LookupDictionary(dv, sources[1]);
                    mult := dim_vec[PositionProperty(VerticesOfQuiver(QuiverOfPathAlgebra(A)), x->(x=vertex))];
                else
                    mat1 := LookupDictionary(mats_dict, __Source_Target_To_String_Code(sources[1],sinks[1]));
                    mult := RankMat(mat1);
                fi;

            elif (Length(sources) = 1) and (Length(sinks) = 2) then
                mat1 := LookupDictionary(mats_dict, __Source_Target_To_String_Code(sources[1],sinks[1]));
                mat2 := LookupDictionary(mats_dict, __Source_Target_To_String_Code(sources[1],sinks[2]));
                mat3 := StackMatricesHorizontalCopy(mat1, mat2);
                mult := RankMat(mat1) + RankMat(mat2) - RankMat(mat3);

            elif (Length(sources) = 2) and (Length(sinks) = 1) then
                mat1 := LookupDictionary(mats_dict, __Source_Target_To_String_Code(sources[1],sinks[1]));
                mat2 := LookupDictionary(mats_dict, __Source_Target_To_String_Code(sources[2],sinks[1]));
                mat3 := StackMatricesVerticalCopy(mat1, mat2);
                mult := RankMat(mat1) + RankMat(mat2) - RankMat(mat3);

            elif (Length(sources) = 2) and (Length(sinks) = 2) then
                mat1 := LookupDictionary(mats_dict, __Source_Target_To_String_Code(sources[1],sinks[2]));
                mat2 := LookupDictionary(mats_dict, __Source_Target_To_String_Code(sources[1],sinks[1]));
                mat3 := LookupDictionary(mats_dict, __Source_Target_To_String_Code(sources[2],sinks[2]));

                r := DimensionsMat(mat3)[1];
                c := DimensionsMat(mat2)[2];
                mat4 := StackMatricesVerticalCopy(StackMatricesHorizontalCopy(mat2, mat1),
                                        StackMatricesHorizontalCopy(NullMat(r,c, F), mat3));
                mult := RankMat(mat1) - RankMat(StackMatricesHorizontalCopy(mat1,mat2)) - RankMat(StackMatricesVerticalCopy(mat3, mat1)) + RankMat(mat4);
            fi;

            if mult <> 0 then
                Add(ans, [I, mult]);
            fi;
        od;
    od;
    
    return ans;
end;


InstallMethod(CompressedMultiplicity,
              "for CommGridRepn",
              ReturnTrue,
              [IsCommGridRepn],
              __CompressedMultiplicity2N);




__IntervalMobiusInversion2N := function(V, cM)
    local ans,
          cM_dict, entry,
          A, n_rows, n_cols,
          intervals, height, I,
          rwbd, coeff, join_card, join_dim_vec, sign, cM_entry;

    cM_dict := NewDictionary("", true);
    for entry in cM do
        AddDictionary(cM_dict,
                      JoinStringsWithSeparator(DimensionVector(entry[1])),
                      entry[2]);
    od;

    ans := [];

    A := RightActingAlgebra(V);
    n_rows := NumCommGridRows(A);
    n_cols := NumCommGridColumns(A);

    if n_rows <> 2 then
        return fail;
    fi;

    intervals := IntervalRepns(A);
    for height in RecNames(intervals) do
        for I in intervals.(height) do
            rwbd := IntervalDimVecToRowWiseBD(DimensionVector(I), n_rows, n_cols);
            coeff := 0;

            for join_card in JoinCoverSubsetsOfRowWiseBD(rwbd, n_rows, n_cols) do
                join_dim_vec := RowWiseBDToIntervalDimVec(join_card[1], n_rows, n_cols);
                sign := (-1) ^ join_card[2];
                cM_entry := LookupDictionary(cM_dict, JoinStringsWithSeparator(join_dim_vec));
                if cM_entry <> fail then
                    coeff := coeff + sign * cM_entry;
                fi;
            od;
            if coeff <> 0 then
                Add(ans, [I, coeff]);
            fi;
        od;
    od;
    return ans;
end;

InstallMethod(IntervalMobiusInversion,
              "for CommGridRepn and a compressed multiplicity",
              ReturnTrue,
              [IsCommGridRepn, IsList],
              __IntervalMobiusInversion2N);


__IntervalApproximation2N := function(V)
    local ans, cM;

    cM := CompressedMultiplicity(V);
    ans := IntervalMobiusInversion(V, cM);

    return ans;
end;


InstallMethod(IntervalApproximation,
              "for CommGridRepn",
              ReturnTrue,
              [IsCommGridRepn],
              __IntervalApproximation2N);
			  
			  
			  
