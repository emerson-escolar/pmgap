
EquiorientedAnPathAlgebra := function(F, n)
    local Q;
    Q := DynkinQuiver("A",n,ListWithIdenticalEntries(n-1,"r"));
    return PathAlgebra(F, Q);
end;

InstallGlobalFunction(CommGridPathAlgebra,
  function(F, n_rows, n_cols)
      local Ar, Ac, A;;
      Ar := EquiorientedAnPathAlgebra(F, n_rows);
      Ac := EquiorientedAnPathAlgebra(F, n_cols);
      A := TensorProductOfAlgebras(Ar, Ac);

      SetFilterObj(A, IsCommGridPathAlgebra);
      SetNumCommGridRows(A, n_rows);
      SetNumCommGridColumns(A, n_cols);

      return A;
  end);
