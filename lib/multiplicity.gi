


# ********** For computing multiplicities **********

DimHomNaive := function(M,N)
    return Length(HomOverAlgebra(M,N));
end;


DimHomCustom := function(M,N)
    # *** COPIED AND MODIFIED FROM GAP QPA modulehom.gi ***
    local A, F, dim_M, dim_N, num_vert, support_M, support_N, num_rows, num_cols,
          block_rows, block_cols, block_intervals,
          i, j, equations, arrows, vertices, v, a, source_arrow, target_arrow,
          mats_M, mats_N, prev_col, prev_row, row_start_pos, col_start_pos,
          row_end_pos, col_end_pos, l, m, n, hom_basis, map, mat, homs, x, y, k, b,
          dim_hom, zero;

    A := RightActingAlgebra(M);
    if A <> RightActingAlgebra(N) then
        Print("The two modules entered are not modules over the same algebra.");
        return fail;
    fi;
    F := LeftActingDomain(A);

    if Dimension(M) = 0 or Dimension(N) = 0 then
        return 0;
    fi;

    # Finding the support of M and N
    vertices := VerticesOfQuiver(QuiverOfPathAlgebra(OriginalPathAlgebra(A)));
    dim_M := DimensionVector(M);
    dim_N := DimensionVector(N);
    num_vert := Length(dim_M);
    support_M := [];
    support_N := [];
    for i in [1..num_vert] do
        if (dim_M[i] <> 0) then
            AddSet(support_M,i);
        fi;
        if (dim_N[i] <> 0) then
            AddSet(support_N,i);
        fi;
    od;
    #
    # Deciding the size of the equations,
    # number of columns and rows
    #
    num_cols := 0;
    num_rows := 0;
    block_intervals := [];
    block_rows := [];
    block_cols := [];
    prev_col := 0;
    prev_row := 0;
    for i in support_M do
        num_rows := num_rows + dim_M[i]*dim_N[i];
        block_rows[i] := prev_row+1;
        prev_row := num_rows;
        for a in OutgoingArrowsOfVertex(vertices[i]) do
            source_arrow := Position(vertices,SourceOfPath(a));
            target_arrow := Position(vertices,TargetOfPath(a));
            if (target_arrow in support_N) and ( (source_arrow in support_N) or (target_arrow in support_M)) then
                num_cols := num_cols + dim_M[source_arrow]*dim_N[target_arrow];
                Add(block_cols,[a,prev_col+1,num_cols]);
            fi;
            prev_col := num_cols;
        od;
    od;
    #
    # Finding the linear equations for the maps between M and N
    #
    equations := NullMat(num_rows, num_cols, F);

    arrows := ArrowsOfQuiver(QuiverOfPathAlgebra(OriginalPathAlgebra(A)));
    mats_M := MatricesOfPathAlgebraModule(M);
    mats_N := MatricesOfPathAlgebraModule(N);
    prev_col := 0;
    prev_row := 0;
    for i in support_M do
        for a in OutgoingArrowsOfVertex(vertices[i]) do
            source_arrow := Position(vertices,SourceOfPath(a));
            target_arrow := Position(vertices,TargetOfPath(a));
            if (target_arrow in support_N) and ( (source_arrow in support_N) or (target_arrow in support_M)) then
                for j in [1..dim_M[source_arrow]] do
                    row_start_pos := block_rows[source_arrow] + (j-1)*dim_N[source_arrow];
                    row_end_pos := block_rows[source_arrow] - 1 + j*dim_N[source_arrow];
                    col_start_pos := prev_col + 1 + (j-1)*dim_N[target_arrow];
                    col_end_pos := prev_col + j*dim_N[target_arrow];
                    if (source_arrow in support_N) then
                        equations{[row_start_pos..row_end_pos]}{[col_start_pos..col_end_pos]} := mats_N[Position(arrows,a)];
                    fi;
                    if (target_arrow in support_M) then
                        for m in [1..DimensionsMat(mats_M[Position(arrows,a)])[2]] do
                            for n in [1..dim_N[target_arrow]] do
                                b := block_rows[target_arrow]+(m-1)*dim_N[target_arrow];
                                equations[b+n-1][col_start_pos+n-1] := equations[b+n-1][col_start_pos+n-1]+(-1)*mats_M[Position(arrows,a)][j][m];
                            od;
                        od;
                    fi;
                od;
                prev_col := prev_col + dim_M[source_arrow]*dim_N[target_arrow];
            fi;
        od;
    od;

    # HEAVILY EDITED:
    if (num_rows <> 0) and (num_cols <> 0) then
        # rank-nullity, matrices operate from the right
        dim_hom := num_rows - RankMatDestructive(equations);
    else
        dim_hom := 0;
        for i in [1..num_vert] do
            # if (dim_M[i] <> 0) and (dim_N[i] <> 0) then
                # for m in BasisVectors(Basis(FullMatrixSpace(F,dim_M[i],dim_N[i]))) do
                #     dim_hom := dim_hom + 1;
                # od;
            dim_hom := dim_hom + (dim_M[i] * dim_N[i]);
            # fi;
        od;
    fi;
    return dim_hom;
end;

InstallMethod(DimHomOverAlgebra,
    "for two representations of a quiver",
    [ IsPathAlgebraMatModule, IsPathAlgebraMatModule ], 0,
    DimHomCustom);




__MultiplicityAtIndec := function(M, I)
    local asseq, middleterm, mult, tauI;
    asseq := AlmostSplitSequence(I);
    if asseq = fail then
        # I is projective!
        middleterm := RadicalOfModule(I);
    else
        middleterm := Range(asseq[1]);
    fi;
    # mult := DimHomNaive(M,I) - DimHomNaive(M, middleterm);
    mult := DimHomOverAlgebra(M,I) - DimHomOverAlgebra(M, middleterm);
    if not asseq = fail then
        tauI := Source(asseq[1]);
        mult := mult + DimHomOverAlgebra(M, tauI);
    fi;
    return mult;
end;




InstallMethod(MultiplicityAtIndec,
              "for a path algebra mat module and indecomposable module",
              ReturnTrue,
              [IsPathAlgebraMatModule,
               IsIndecomposableModule],
              __MultiplicityAtIndec);


InstallMethod(ComputeMultiplicities,
              "for a path algebra mat module and a list of indecomposable modules",
              ReturnTrue,
              [IsPathAlgebraMatModule, IsListOrCollection],
              function(M, list_of_indecs)
                  local  N, i, multmap;
                  N := Length(list_of_indecs);
                  multmap := [];
                  for i in [1..N] do
                      multmap[i] := [list_of_indecs[i], MultiplicityAtIndec(M, list_of_indecs[i])];
                  od;
                  return multmap;
              end);
