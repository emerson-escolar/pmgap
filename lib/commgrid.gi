
InstallGlobalFunction(EquiorientedAnPathAlgebra,
function(F, n)
    local Q, A;
    Q := DynkinQuiver("A",n,ListWithIdenticalEntries(n-1,"r"));
    A := PathAlgebra(F, Q);
    SetFilterObj(A, IsEquiorientedAnPathAlgebra);
    return A;
end);


__CommGridPathAlgebraByTensor := function(F, n_rows, n_cols)
    local Ar, Ac, A;;
    Ar := EquiorientedAnPathAlgebra(F, n_rows);
    Ac := EquiorientedAnPathAlgebra(F, n_cols);
    A := TensorProductOfAlgebras(Ar, Ac);
    return A;
end;


__CommGridByTensorRowColumnToVertexDict := function(A)
    local n_rows, n_cols, i, j, v, name, dict;

    n_rows := NumCommGridRows(A);
    n_cols := NumCommGridColumns(A);
    dict := NewDictionary(false, true);
    for i in [1..n_rows] do
        for j in [1..n_cols] do
            name := JoinStringsWithSeparator([String(i),String(j)],"_");
            for v in VerticesOfQuiver(QuiverOfPathAlgebra(A)) do
                if name = String(v) then
                    AddDictionary(dict, [i,j], v);
                    continue;
                fi;
            od;
        od;
    od;
    return dict;
end;



# UNUSED
__CommGridPathAlgebraByPoset := function(F, n_rows, n_cols)
    local vertex, vertices, relations, VertexCode,
          i,j,
          A;
    VertexCode := function(i,j)
        return Concatenation(Concatenation(String(i),"_"),
                             String(j));
    end;
    vertices := [];
    relations := [];
    for i in [1..n_rows-1] do
        for j in [1..n_cols-1] do
            vertex := VertexCode(i,j);
            Add(vertices, vertex);
            Add(relations, [vertex,
                            VertexCode(i+1,j),
                            VertexCode(i,j+1)]);
        od;
    od;

    j := n_cols;
    for i in [1..n_rows-1] do
        vertex := VertexCode(i,j);
        Add(vertices, vertex);
        Add(relations, [vertex, VertexCode(i+1,j)]);
    od;

    i := n_rows;
    for j in [1..n_cols-1] do
        vertex := VertexCode(i,j);
        Add(vertices, vertex);
        Add(relations, [vertex, VertexCode(i,j+1)]);
    od;
    Add(vertices, VertexCode(n_rows, n_cols));

    A := PosetAlgebra(F, Poset(vertices, relations));
    return A;
end;
# END UNUSED




__ComputeArrowsDict := function(A)
    local dict,
          arr;

    dict := NewDictionary(false, true);
    for arr in ArrowsOfQuiver(QuiverOfPathAlgebra(A)) do
        AddDictionary(dict,
                      [String(SourceVertex(arr)),
                       String(TargetVertex(arr))],
                      arr);
    od;
    return dict;
end;


# CommGridPathAlgebraByTensor is faster
InstallGlobalFunction(CommGridPathAlgebra,
                     function(F, n_rows, n_cols)
                         local A;
                         A := __CommGridPathAlgebraByTensor(F, n_rows, n_cols);
                         SetFilterObj(A, IsCommGridPathAlgebra);
                         SetNumCommGridRows(A, n_rows);
                         SetNumCommGridColumns(A, n_cols);

                         SetCommGridRowColumnToVertexDict(A, __CommGridByTensorRowColumnToVertexDict(A));
                         SetCommGridSourceTargetToArrowDict(A,__ComputeArrowsDict(A));
                         return A;
                     end);


InstallMethod(CommGridRowColumnDirectionToArrow,
              "for comm grid, [row_index, col_index], direction",
              ReturnTrue,
              [IsCommGridPathAlgebra, IsList, IsChar],
              function(A, s, dir)
                  local dv, da, a_s, a_t, t1, t2, arr;
                  dv := CommGridRowColumnToVertexDict(A);
                  da := CommGridSourceTargetToArrowDict(A);

                  a_s := LookupDictionary(dv, [s[1], s[2]]);
                  if dir = 'r' then
                      t1 := s[1] + 1;
                      t2 := s[2];
                  elif dir = 'c' then
                      t1 := s[1];
                      t2 := s[2] + 1;
                  else
                      return fail;
                  fi;
                  a_t := LookupDictionary(dv, [t1, t2]);
                  if a_t = fail then
                      return fail;
                  fi;
                  arr := LookupDictionary(da, [String(a_s), String(a_t)]);
                  return arr;
              end);


InstallMethod(CommGridPath,
              "for comm grid",
              ReturnTrue,
              [IsCommGridPathAlgebra, IsList, IsList],
              function(A, s, t)
                  local dv, p, i, arr;
                  if (t[1] < s[1]) or (t[2] < s[2]) then
                      return fail;
                  fi;

                  dv := CommGridRowColumnToVertexDict(A);
                  p := LookupDictionary(dv, [s[1],s[2]]);
                  if (p = fail) or (LookupDictionary(dv, [t[1],t[2]]) = fail) then
                      return fail;
                  fi;

                  for i in [s[1]+1..t[1]] do
                      arr := CommGridRowColumnDirectionToArrow(A, [i-1, s[2]], 'r');
                      p := p * arr;
                  od;
                  for i in [s[2]+1..t[2]] do
                      arr := CommGridRowColumnDirectionToArrow(A, [t[1], i-1], 'c');
                      p := p * arr;
                  od;
                  return p;
              end);
