



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
