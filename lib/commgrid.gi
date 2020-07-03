
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

    SetFilterObj(A, IsCommGridPathAlgebra);
    SetNumCommGridRows(A, n_rows);
    SetNumCommGridColumns(A, n_cols);

    return A;
end;



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

    SetFilterObj(A, IsCommGridPathAlgebra);
    SetNumCommGridRows(A, n_rows);
    SetNumCommGridColumns(A, n_cols);
    return A;
end;


# CommGridPathAlgebraByTensor is faster
InstallGlobalFunction(CommGridPathAlgebra,
                      __CommGridPathAlgebraByTensor);
