
### -------------------- IntervalDimVec(s) --------------------
# Assumes that the vertices of the commgridpathalgebra is ordered in a very specific way!
# In terms of (row,col) indices, ordered as:
# (1,1) (1,2) ... (1,n_cols) (2,1) (2,2) ... (2,n_cols) (n_rows,1) (n_rows,2) ... (n_rows,n_cols)


# -------------------- Formats & Checks --------------------
__IntervalDimVecToRowWiseBD := function(dimvec, n_rows, n_cols)
    local zero, ans,
          i, slice, b, d;
    if not (CheckCommGridIntervalDimVec(dimvec, n_rows, n_cols)) then
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
              "for a dimvec, row_num, col_num",
              ReturnTrue,
              [IsList, IsInt, IsInt],
              __IntervalDimVecToRowWiseBD);


InstallMethod(RowWiseBDToIntervalDimVec,
              "for a rowwisebd, row_num, col_num",
              ReturnTrue,
              [IsList, IsInt, IsInt],
              function(rwbd, r, c)
                  local dimv, i, l, bd;
                  if not CheckRowWiseBD(rwbd, r, c) then
                      return fail;
                  fi;
                  dimv := [];

                  for i in [1..r] do
                      l := Length(dimv);
                      Append(dimv, ListWithIdenticalEntries(c, 0));
                      if rwbd[i] <> false then
                          bd := rwbd[i];
                          dimv{[l+bd[1]..l+bd[2]]} := ListWithIdenticalEntries(bd[2] - bd[1] + 1, 1);
                      fi;
                  od;
                  return dimv;
              end);


InstallMethod(CheckRowWiseBD,
              "for a rowwisebd, row_num, col_num",
              ReturnTrue,
              [IsList, IsInt, IsInt],
              function(rwbd, r, c)
                  local nonfalse, i, prev_b, prev_d, cur_b, cur_d;
                  if Length(rwbd) <> r then
                      return false;
                  fi;
                  # check contiguity of interval stacks
                  nonfalse := PositionsProperty(rwbd, x->(x<>false));

                  if (Length(nonfalse) = 0) or (nonfalse <> [nonfalse[1]..nonfalse[Length(nonfalse)]]) then
                      return false;
                  fi;
                  # check numbers
                  for i in nonfalse do
                      if (Length(rwbd[i]) <> 2) or not IsInt(rwbd[i][1]) or not IsInt(rwbd[i][2]) or not (1 <= rwbd[i][1] and rwbd[i][1] <= c) or not (1 <= rwbd[i][2] and rwbd[i][2] <= c) then
                          return false;
                      fi;
                  od;
                  # check staircase property
                  prev_b := rwbd[nonfalse[1]][1];
                  prev_d := rwbd[nonfalse[1]][2];
                  for i in nonfalse{[2..Length(nonfalse)]} do
                      cur_b := rwbd[i][1];
                      cur_d := rwbd[i][2];
                      if not ((cur_b <= prev_b) and (prev_b <= cur_d) and (cur_d <= prev_d)) then
                          return false;
                      fi;
                      prev_b := cur_b;
                      prev_d := cur_d;
                  od;
                  return true;
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


__CheckCommGridIntervalDimVec := function(dim_vec, n_rows, n_cols)
    local cur_stop, bd, invalid_entry,
          prev_birth, prev_death,
          remaining;

    if not (Length(dim_vec) = n_rows * n_cols) then
        # TODO: message?
        return false;
    fi;
    invalid_entry := PositionProperty(dim_vec, x->(x<>1 and x <> 0));
    if not (invalid_entry = fail) then
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



# -------------------- Generation --------------------

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

__IntervalRepresentationsList := function(A)
    local I, ans, height, foo;
    I := IntervalRepns(A);
    ans := [];
    for height in RecNames(I) do
        for foo in I.(height) do
            Add(ans, foo);
        od;
    od;
    return ans;
end;


InstallMethod(IntervalRepnsList,
              "for commutative grid",
              ReturnTrue,
              [IsCommGridPathAlgebra],
              __IntervalRepresentationsList);

InstallOtherMethod(IntervalRepnsList,
                   "for a equioriented An path algebra",
                   ReturnTrue,
                   [IsEquiorientedAnPathAlgebra],
                   __IntervalRepresentationsList);



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

# InstallMethod(PrintObj,
#               "for a commutative grid interval repn",
#               ReturnTrue,
#               [IsCommGridInterval],
#               NICE_FLAGS + 1,
#               function(I)
#                   local dim_vec,
#                         A, n_cols;
#                   A := RightActingAlgebra(I);
#                   n_cols := NumCommGridColumns(A);
#                   dim_vec := DimensionVector(I);
#                   PrettyPrintCommutativeGridDimVec(dim_vec, n_cols);
#                   return;
#               end);


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




InstallMethod(SourceVertices,
              "for comm grid interval",
              ReturnTrue,
              [IsCommGridInterval],
              function(V)
                  local A, n_rows, n_cols,
                        rwbd,
                        nonempty_row_indices, i,
                        prev_b, cur_b,
                        ans;
                  A := RightActingAlgebra(V);
                  n_rows := NumCommGridRows(A);
                  n_cols := NumCommGridColumns(A);
                  rwbd := IntervalDimVecToRowWiseBD(DimensionVector(V), n_rows, n_cols);
                  nonempty_row_indices := PositionsProperty(rwbd, x->(x<>false));

                  prev_b := rwbd[nonempty_row_indices[1]][1];
                  ans := [[nonempty_row_indices[1], prev_b]];
                  for i in nonempty_row_indices{[2..Length(nonempty_row_indices)]} do
                      cur_b := rwbd[i][1];
                      if cur_b < prev_b then
                          Add(ans, [i, cur_b]);
                      fi;
                      prev_b := cur_b;
                  od;
                  return ans;
             end);

InstallMethod(SinkVertices,
              "for comm grid interval",
              ReturnTrue,
              [IsCommGridInterval],
              function(V)
                  local A, n_rows, n_cols,
                        rwbd,
                        nonempty_row_indices, i,
                        prev_d, cur_d,
                        ans;
                  A := RightActingAlgebra(V);
                  n_rows := NumCommGridRows(A);
                  n_cols := NumCommGridColumns(A);
                  rwbd := IntervalDimVecToRowWiseBD(DimensionVector(V), n_rows, n_cols);

                  nonempty_row_indices := PositionsProperty(rwbd, x->(x<>false));

                  prev_d := rwbd[nonempty_row_indices[1]][2];
                  i := nonempty_row_indices[1];
                  ans := [];
                  for i in nonempty_row_indices{[2..Length(nonempty_row_indices)]} do
                      cur_d := rwbd[i][2];
                      if cur_d < prev_d then
                          Add(ans, [i-1, prev_d]);
                      fi;
                      prev_d := cur_d;
                  od;
                  Add(ans, [i, prev_d]);
                  return ans;
             end);


InstallMethod(UpsetPresentation,
              "for comm grid interval",
              ReturnTrue,
              [IsCommGridInterval],
              function(V)
                  local A, n_rows, n_cols,
                        rwbd,
                        nonempty_row_indices, i,
                        cur_b, cur_d,
                        U_rwbd, U,
                        C_rwbd, C;
                  A := RightActingAlgebra(V);
                  n_rows := NumCommGridRows(A);
                  n_cols := NumCommGridColumns(A);

                  rwbd := IntervalDimVecToRowWiseBD(DimensionVector(V), n_rows, n_cols);
                  nonempty_row_indices := PositionsProperty(rwbd, x->(x<>false));

                  # compute the upset and co-upset of V
                  i := 1;
                  U_rwbd := [];
                  C_rwbd := [];
                  while i < nonempty_row_indices[1] do
                      Add(U_rwbd, false);
                      Add(C_rwbd, false);
                      i := i+1;
                  od;
                  
                  for i in nonempty_row_indices{[1..Length(nonempty_row_indices)]} do
                      cur_b := rwbd[i][1];
                      Add(U_rwbd, [cur_b, n_cols]);

                      cur_d := rwbd[i][2];
                      if cur_d + 1 > n_cols then
                          Add(C_rwbd, false);
                      else
                          Add(C_rwbd, [cur_d + 1, n_cols]);
                      fi;
                  od;
                  i := i+1;
                  while i <= n_rows do
                      Add(U_rwbd, [cur_b, n_cols]);
                      Add(C_rwbd, [cur_b, n_cols]);
                      i := i+1;
                  od;

                  # Print(U_rwbd);
                  # Print("\n");
                  # Print(C_rwbd);
                  # Print("\n");

                  U := IntervalRepn(A, RowWiseBDToIntervalDimVec(U_rwbd, n_rows, n_cols));

                  if U_rwbd <> rwbd then
                      C := IntervalRepn(A, RowWiseBDToIntervalDimVec(C_rwbd, n_rows, n_cols));
                  else
                      C := fail;
                  fi;



                  return [U,C];
             end);


__CoverModsOfRowWiseBD := function(rwbd, r, c)
    # Compute modifications need to make to rwbd in order to
    # obtain its cover.
    # output as a list `ans` of [row_index, [b,d]] elements,
    # where each entry in `ans` corresponds to one cover element U
    # giving the [b,d] of U at row_index.

    local ans, nonempty_row_indices,
          i,
          prev_b, prev_d,
          cur_b, cur_d;

    if not CheckRowWiseBD(rwbd, r, c) then
        return fail;
    fi;

    ans := [];
    nonempty_row_indices := PositionsProperty(rwbd, x->(x<>false));

    # FIRST NONEMPTY ROW
    i := nonempty_row_indices[1];
    cur_b := rwbd[i][1];
    cur_d := rwbd[i][2];

    if i > 1 then
        Add(ans, [i-1, [cur_d, cur_d]]);
    fi;
    if cur_d < c then
        Add(ans, [i, [cur_b, cur_d + 1]]);
    fi;
    prev_b := cur_b;
    prev_d := cur_d;

    for i in nonempty_row_indices{[2..Length(nonempty_row_indices)]} do
        cur_b := rwbd[i][1];
        cur_d := rwbd[i][2];
        if cur_d < prev_d then
            Add(ans, [i, [cur_b, cur_d + 1]]);
        fi;
        if cur_b < prev_b then
            Add(ans, [i-1, [prev_b-1, prev_d]]);
        fi;

        prev_b := cur_b;
        prev_d := cur_d;
    od;

    # LAST NONEMPTY ROW
    # i := nonempty_row_indices[Length(nonempty_row_indices)];
    if cur_b > 1 then
        Add(ans, [i, [cur_b-1, cur_d]]);
    fi;
    if i < r then
        Add(ans, [i+1, [cur_b,cur_b]]);
    fi;

    return ans;
end;








InstallMethod(CoverOfRowWiseBD,
              "for a rowwisebd, row_num, col_num",
              ReturnTrue,
              [IsList, IsInt, IsInt],
              function(rwbd, r, c)
                  local ans, cur_list,
                        cover_mods, i_bd;

                  cover_mods := __CoverModsOfRowWiseBD(rwbd, r, c);
                  if cover_mods = fail then
                      return fail;
                  fi;

                  ans := [];
                  for i_bd in cover_mods do
                      cur_list := StructuralCopy(rwbd);
                      cur_list[i_bd[1]] := StructuralCopy(i_bd[2]);
                      Add(ans, cur_list);
                  od;

                  return ans;
              end);




__CheckAndFixNextRowBirth := function(cur_list, row)
    if cur_list[row+1] <> false and cur_list[row][1] < cur_list[row+1][1] then
        cur_list[row+1][1] := cur_list[row][1];
    fi;
    return cur_list;
end;

__CheckAndFixPreviousRowDeath := function(cur_list, row)
    if cur_list[row-1] <> false and cur_list[row][2] > cur_list[row-1][2] then
        cur_list[row-1][2] := cur_list[row][2];
    fi;
    return cur_list;
end;

# The following computes joins of subsets of the cover of an interval.
# It takes advantange of the particular shape of intervals (staircases)
# and that cover elements have exactly only one more vertex.
# Most cover joins would then just be a simple union,
# but in cases where both the upper-right vertices are added,
# and/or both lower-left vertices are added, we need to
# do a pushout and/or a pullback operation to make it an interval.
# These are performed by the CheckAndFix subroutines above.
InstallMethod(JoinCoverSubsetsOfRowWiseBD,
              "for a rowwisebd, row_num, col_num",
              ReturnTrue,
              [IsList, IsInt, IsInt],
              function(rwbd, r, c)
                  local ans, nonempty_row_indices,
                        first_row, last_row,
                        check_first_d, check_last_b,
                        cover_mods,
                        comb, card, cur_list,
                        i_bd;

                  ans := [];
                  nonempty_row_indices := PositionsProperty(rwbd, x->(x<>false));
                  first_row := nonempty_row_indices[1];
                  last_row := nonempty_row_indices[Length(nonempty_row_indices)];

                  if first_row > 1 and rwbd[first_row][2] < c then
                      check_first_d := true;
                  else
                      check_first_d := false;
                  fi;
                  if last_row < r and rwbd[last_row][1] > 1 then
                      check_last_b := true;
                  else
                      check_last_b := false;
                  fi;

                  cover_mods := __CoverModsOfRowWiseBD(rwbd, r, c);

                  if cover_mods = fail then
                      return fail;
                  fi;

                  if Length(cover_mods) = 0 then
                      return [[StructuralCopy(rwbd),0]];
                  fi;

                  for comb in IteratorOfCombinations(cover_mods) do
                      card := Length(comb);
                      cur_list := StructuralCopy(rwbd);
                      for i_bd in comb do
                          if cur_list[i_bd[1]] = false then
                              cur_list[i_bd[1]] := StructuralCopy(i_bd[2]);
                          else
                              cur_list[i_bd[1]][1] := Minimum(cur_list[i_bd[1]][1], i_bd[2][1]);
                              cur_list[i_bd[1]][2] := Maximum(cur_list[i_bd[1]][2], i_bd[2][2]);
                          fi;
                      od;
                      if check_last_b = true then
                          cur_list := __CheckAndFixNextRowBirth(cur_list, last_row);
                      fi;
                      if check_first_d = true then
                          cur_list := __CheckAndFixPreviousRowDeath(cur_list, first_row);
                      fi;
                      Add(ans, [cur_list, card]);
                  od;

                  return ans;
              end);
