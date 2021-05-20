
### -------------------- IntervalDimVec(s) --------------------
# Assumes that the vertices of the commgridpathalgebra is ordered in a very specific way!
# In terms of (row,col) indices, ordered as:
# (1,1) (1,2) ... (1,n_cols) (2,1) (2,2) ... (2,n_cols) (n_rows,1) (n_rows,2) ... (n_rows,n_cols)



__IntervalDimVecToRowWiseBD := function(dimvec, n_rows, n_cols)
    local invalid_entry,
          zero, ans,
          i, slice, b, d;
    if not (CheckCommGridIntervalDimVec(dimvec)) then
        return fail;
    fi;
    
    invalid_entry := PositionProperty(dimvec, x->(x<>1 and x <> 0));
    if not (invalid_entry = fail) then
        return fail;
    fi;

    zero := ListWithIdenticalEntries(n_cols, 0);
    ans := [];
    for i in [1..n_rows] do
        slice := dimvec{[(i-1)*n_cols+1..(i)*n_cols]};
        if slice = zero then
            Add(ans, false);
            continue;
        fi;
        b := PositionProperty(slice, x->x=1);
        d := n_cols - PositionProperty(Reversed(slice), x->x=1) + 1;
        Add(ans, [b,d]);
    od;
    return ans;
end;



InstallMethod(IntervalDimVecToRowWiseBD,
              "for a commutative grid path algebra",
              ReturnTrue,
              [IsList, IsInt, IsInt],
              __IntervalDimVecToRowWiseBD);


InstallMethod(RowWiseBDToIntervalDimVec,
              "for a commutative grid path algebra",
              ReturnTrue,
              [IsList, IsInt, IsInt],
              function(rwbd, r, c)
                  local dimv, i, l, bd;
                  if Length(rwbd) <> r then
                      return fail;
                  fi;

                  dimv := [];
                  for i in [1..r] do
                      l := Length(dimv);
                      Append(dimv, ListWithIdenticalEntries(c, 0));
                      if not (rwbd[i] = false) then
                          bd := rwbd[i];
                          dimv{[l+bd[1]..l+bd[2]]} := ListWithIdenticalEntries(bd[2] - bd[1] + 1, 1);
                      fi;
                  od;
                  if not (CheckCommGridIntervalDimVec(dimv, r, c)) then
                      return fail;
                  fi;
                  return dimv;
              end);



__LastBirthDeath := function(partial_dim_vec, n_cols)
    # figure out the last birth-death indices of a partially completed interval dimension vector
    # last means the last partially-completed row
    # returns fail if the last partially-completed row is all 0

    local cur_row, birth, death;
    cur_row := Int(Ceil(1.*Length(partial_dim_vec)/n_cols));
    birth := PositionProperty(partial_dim_vec, x->x=1, (cur_row-1)*n_cols);
    if birth = fail then
        death := fail;
    else
        birth := (birth-1) mod n_cols +1;
        death := Length(partial_dim_vec) -  PositionProperty(Reversed(partial_dim_vec), x->x=1) + 1;
        death := (death-1) mod n_cols + 1;
    fi;
    return [birth,death];
end;


__CommGridIntervalDimVecsPointed := function(n_rows, n_cols, start_row, end_col)
    # Generate intervals with
    # rows starting from start_row
    # cols up to end_col
    # "height" denotes the number of stacked nonzero rows.

    local graded_intervals, dimvec,
          b, d, x, height, max_height, bd, old_int;

    graded_intervals := rec( 1 := [] );
    dimvec := ListWithIdenticalEntries(n_cols*(start_row-1), 0);
    # Generate height 1 graded_intervals
    # intervals have endpoint at end_col
    for b in [1..end_col] do
        x := Concatenation(dimvec, ListWithIdenticalEntries(b - 1, 0));
        Append(x, ListWithIdenticalEntries(end_col - b + 1, 1));
        Append(x, ListWithIdenticalEntries(n_cols - end_col, 0));
        Add(graded_intervals.1, x);
    od;

    max_height := n_rows - start_row + 1;
    for height in [2..max_height] do
        graded_intervals.(height) := [];

        for old_int in graded_intervals.(height-1) do
            bd := __LastBirthDeath(old_int, n_cols);
            # Generate next-height graded_intervals
            # next interval to stack is [b,d] with b <= bd[1] <= d <= bd[2]
            for b in [1..bd[1]] do
                for d in [bd[1]..bd[2]] do
                    x := Concatenation(old_int, ListWithIdenticalEntries(b - 1, 0));
                    Append(x, ListWithIdenticalEntries(d - b + 1, 1));
                    Append(x, ListWithIdenticalEntries(n_cols - d, 0));
                    Add(graded_intervals.(height), x);
                od;
            od;
            # finish up previous-height graded_intervals
            Append(old_int, ListWithIdenticalEntries(n_rows * n_cols - Length(old_int), 0));
        od;
    od;

    # finish up previous-height graded_intervals
    for old_int in graded_intervals.(max_height) do
        Append(old_int, ListWithIdenticalEntries(n_rows * n_cols - Length(old_int), 0));
    od;
    return graded_intervals;
end;


__MergeIntoRecord_Lists := function(target, source)
    local i;
    for i in RecNames(source) do
        if not IsBound(target.(i)) then
            target.(i) := source.(i);
        else
            Append(target.(i), source.(i));
        fi;
    od;
end;


__CommGridIntervalDimVecs := function(n_rows, n_cols)
    local interval_dimvecs, gr, start_row, end_col;
    interval_dimvecs := rec();
    for start_row in [1..n_rows] do
        for end_col in [1..n_cols] do
            gr := __CommGridIntervalDimVecsPointed(n_rows, n_cols, start_row, end_col);
            __MergeIntoRecord_Lists(interval_dimvecs, gr);
        od;
    od;
    return interval_dimvecs;
end;


InstallMethod(IntervalDimVecs,
              "for a commutative grid path algebra",
              ReturnTrue,
              [IsCommGridPathAlgebra],
              function(A)
                  local idv;
                  idv :=__CommGridIntervalDimVecs(NumCommGridRows(A), NumCommGridColumns(A));
                  return idv;
              end);

InstallOtherMethod(IntervalDimVecs,
                   "for a equioriented An path algebra",
                   ReturnTrue,
                   [IsEquiorientedAnPathAlgebra],
                   function(A)
                       local N, b, d, dimv, idv;
                       N := NumberOfVertices(QuiverOfPathAlgebra(A));
                       idv := rec(1:=[]);
                       for b in [1..N] do
                           for d in [b..N] do
                               dimv := ListWithIdenticalEntries(N,0);
                               dimv{[b..d]} := ListWithIdenticalEntries(d - b + 1,1);
                               Add(idv.1, dimv);
                           od;
                       od;
                       return idv;
                   end);



### -------------------- IntervalRepn(s) --------------------

__CheckCommGridIntervalDimVec := function(dim_vec, n_rows, n_cols)
    local cur_stop, bd,
          prev_birth, prev_death,
          remaining;

    if not (Length(dim_vec) = n_rows * n_cols) then
        # TODO: message?
        return false;
    fi;

    cur_stop := n_rows * n_cols;
    bd := __LastBirthDeath(dim_vec, n_cols);
    while (bd[1] = fail) do
        cur_stop := cur_stop - n_cols;
        if cur_stop = 0 then return false; fi;
        bd := __LastBirthDeath(dim_vec{[1..cur_stop]}, n_cols);
    od;

    prev_birth := bd[1]; prev_death := bd[2];
    while cur_stop > 0 do
        cur_stop := cur_stop - n_cols;
        bd := __LastBirthDeath(dim_vec{[1..cur_stop]}, n_cols);
        if bd[1] = fail then break; fi;
        if not (prev_birth <= bd[1] and bd[1] <= prev_death and
                prev_death <= bd[2]) then
            return false;
        fi;
        prev_birth := bd[1]; prev_death := bd[2];
    od;
    if cur_stop > 0 then
        cur_stop := cur_stop - n_cols;
        remaining := dim_vec{[1..cur_stop]};
        if not (remaining = ListWithIdenticalEntries(Length(remaining),0)) then
            return false;
        fi;
    fi;
    return true;
end;

InstallMethod(CheckCommGridIntervalDimVec,
              "for a dimvec, row_num, col_num",
              ReturnTrue,
              [IsList, IsInt, IsInt],
              __CheckCommGridIntervalDimVec);



__CheckAnIntervalDimVec := function(dim_vec, N)
    local bd, i;
    if not (N = Length(dim_vec)) then
        # TODO: message?
        return false;
    fi;
    bd := __LastBirthDeath(dim_vec, N);
    if bd[1] = fail then
        return false;
    fi;
    for i in [bd[1]..bd[2]] do
        if not (dim_vec[i] = 1) then
            return false;
        fi;
    od;
    return true;
end;

InstallMethod(CheckAnIntervalDimVec,
              "for a dimvec, verts_num",
              ReturnTrue,
              [IsList, IsInt],
              __CheckAnIntervalDimVec);


__CreateObviousIndecMatrices := function(A, dimv)
    local F, dim, matrices, verts, arr, src, trgt;
    for dim in dimv do
        if not (dim = 0 or dim = 1) then
            return fail;
        fi;
    od;
    F := LeftActingDomain(A);
    matrices := [];
    verts := VerticesOfQuiver(QuiverOfPathAlgebra(A));
    for arr in ArrowsOfQuiver(QuiverOfPathAlgebra(A)) do
        src := VertexIndex(SourceVertex(arr));
        if dimv[src] = 0 then continue; fi;
        trgt := VertexIndex(TargetVertex(arr));
        if dimv[trgt] = 0 then continue; fi;
        Add(matrices, [String(arr), Identity(F) * [[1]]]);
    od;
    return matrices;
end;




InstallMethod(IntervalRepn,
              "for commutative grid and a dimension vector",
              ReturnTrue,
              [IsCommGridPathAlgebra, IsCollection],
              function(A, dimv)
                  local V, mats;
                  if not CheckCommGridIntervalDimVec(dimv, NumCommGridRows(A), NumCommGridColumns(A)) then
                      return fail;
                  fi;
                  mats := __CreateObviousIndecMatrices(A,dimv);
                  V := RightModuleOverPathAlgebra(A,dimv,mats);
                  SetFilterObj(V, IsCommGridRepn);
                  SetFilterObj(V, IsCommGridInterval);
                  return V;
              end);

InstallOtherMethod(IntervalRepn,
              "for equioriented A_n and a dimension vector",
              ReturnTrue,
              [IsEquiorientedAnPathAlgebra, IsCollection],
              function(A, dimv)
                  local V, mats;
                  if not CheckAnIntervalDimVec(dimv, NumberOfVertices(QuiverOfPathAlgebra(A))) then return fail; fi;
                  mats := __CreateObviousIndecMatrices(A,dimv);
                  V := RightModuleOverPathAlgebra(A,dimv,mats);
                  SetFilterObj(V, IsEquiorientedAnRepn);
                  SetFilterObj(V, IsEquiorientedAnInterval);
                  return V;
              end);


__IntervalRepresentations := function(A)
    local ans, height, dv;
    ans := rec();
    for height in RecNames(IntervalDimVecs(A)) do
        ans.(height) := [];
        for dv in IntervalDimVecs(A).(height) do
            Add(ans.(height), IntervalRepn(A,dv));
        od;
    od;
    return ans;
end;


InstallMethod(IntervalRepns,
              "for a commutative grid path algebra",
              ReturnTrue,
              [IsCommGridPathAlgebra],
              __IntervalRepresentations);

InstallOtherMethod(IntervalRepns,
                   "for a equioriented An path algebra",
                   ReturnTrue,
                   [IsEquiorientedAnPathAlgebra],
                   __IntervalRepresentations);



### -------------------- Print --------------------

PrettyPrintCommutativeGridDimVec := function(dim_vec, n_cols)
    local counter, d;
    counter := 0;
    Print("-------------------------------\n");
    Print("Interval with dimension vector:\n");
    for d in dim_vec do
        Print(d);
        counter := counter + 1;
        if counter mod n_cols = 0 then
            Print("\n");
        fi;
    od;
    Print("-------------------------------");
end;

InstallMethod(PrintObj,
              "for a commutative grid interval repn",
              ReturnTrue,
              [IsCommGridInterval],
              NICE_FLAGS + 1,
              function(I)
                  local dim_vec,
                        A, n_cols;
                  A := RightActingAlgebra(I);
                  n_cols := NumCommGridColumns(A);
                  dim_vec := DimensionVector(I);
                  PrettyPrintCommutativeGridDimVec(dim_vec, n_cols);
                  return;
              end);


### -------------------- IntervalPart & Friends --------------------

__IntervalPart := function(V)
    local A, ans, zero, rem_dv, i, dv, I, mult;

    A := RightActingAlgebra(V);
    ans := [];
    zero := ListWithIdenticalEntries(Size(VerticesOfPathAlgebra(A)), 0);
    rem_dv := DimensionVector(V);

    # Generate the interval representations
    for i in RecNames(IntervalDimVecs(A)) do
        for dv in IntervalDimVecs(A).(i) do
            if not (dv <= rem_dv) then continue; fi;
            I := IntervalRepn(A,dv);
            mult := MultiplicityAtIndec(V, I);
            if mult = 0 then continue; fi;
            Add(ans, [I, mult]);
            rem_dv := rem_dv - (mult * dv);
            if rem_dv = zero then return ans; fi;
        od;
    od;
    return ans;
end;

__IntervalPartCachedRepns := function(V)
    local A, ans, zero, rem_dv, i, dv, I, mult;

    A := RightActingAlgebra(V);
    ans := [];
    zero := ListWithIdenticalEntries(Size(VerticesOfPathAlgebra(A)), 0);
    rem_dv := DimensionVector(V);

    # Generate the interval representations
    for i in RecNames(IntervalRepns(A)) do
        for I in IntervalRepns(A).(i) do
            if not (DimensionVector(I) <= rem_dv) then continue; fi;
            mult := MultiplicityAtIndec(V, I);
            if mult = 0 then continue; fi;
            Add(ans, [I, mult]);
            rem_dv := rem_dv - (mult * DimensionVector(I));
            if rem_dv = zero then return ans; fi;
        od;
    od;
    return ans;
end;

InstallMethod(IntervalPart,
              "for a comm grid repn",
              ReturnTrue,
              [IsCommGridRepn],
              __IntervalPartCachedRepns);


__IntervalPartDimVec := function(V)
    local A, pair, cum_dv, I, mult;

    A := RightActingAlgebra(V);
    cum_dv := ListWithIdenticalEntries(Size(VerticesOfPathAlgebra(A)), 0);

    for pair in IntervalPart(V) do
        I := pair[1];
        mult := pair[2];
        cum_dv := cum_dv + (mult * DimensionVector(I));
    od;
    return cum_dv;
end;

InstallMethod(IntervalPartDimVec,
              "for a comm grid repn",
              ReturnTrue,
              [IsCommGridRepn],
              __IntervalPartDimVec);




__IsIntervalDecomposable := function(V)
    return DimensionVector(V) = IntervalPartDimVec(V);
end;


InstallMethod(IsIntervalDecomposable,
              "for comm grid repn",
              ReturnTrue,
              [IsCommGridRepn],
              __IsIntervalDecomposable);
