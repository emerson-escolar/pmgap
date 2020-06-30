# Copied from gyoza:
# https://bitbucket.org/remere/gyoza/src/master/
# GPL3


# ********** For computing multiplicities **********

NumBasisHom := function(M,N)
    return Length(HomOverAlgebra(M,N));
end;

MultiplicityAtIndec := function(M, I)
    local ai, arseq, middleterm, dec_res, i, mult, tauI, n;
    arseq := AlmostSplitSequence(I);
    if arseq = fail then
        # I is projective!
        middleterm := RadicalOfModule(I);
    else
        middleterm := Range(arseq[1]);
    fi;
    dec_res := DecomposeModuleWithMultiplicities(middleterm);
    # decomposition of middle term fails when it is a zero module.
    # This happens when I is simple projective, zero radical.

    ai := NumBasisHom(M,I);
    if not dec_res = fail then
        n := Length(dec_res[1]);
        for i in [1..n] do
            mult := dec_res[2][i];
            ai := ai - mult * NumBasisHom(M, dec_res[1][i]);
        od;
    fi;

    if not arseq = fail then
        tauI := Source(arseq[1]);
        ai := ai + NumBasisHom(M, tauI);
    fi;
    return ai;
end;


ComputeMultiplicities := function(M, list_of_indecs)
    local  N, i, multmap;
    N := Length(list_of_indecs);
    multmap := [];
    for i in [1..N] do
        multmap[i] := [list_of_indecs[i], MultiplicityAtIndec(M, list_of_indecs[i])];
    od;
    return multmap;
end;

DisplayMultiplicities := function(multmap)
    local  x;
    for x in multmap do
        Print(DimensionVector(x[1]), ": ", x[2], "\n");
    od;
end;


# ****************************************

# ********** For computing isoclasses of indecomposables **********
GetCandidateIndecs := function(A, search_distance)
    local  injs, M, list_of_indecs, i, res;
    injs := IndecInjectiveModules(A);
    M := Length(injs);
    list_of_indecs := [];;
    for i in [1..M] do
        if not IsProjectiveModule(injs[i]) then
            res := PredecessorsOfModule(injs[i],search_distance);;
            list_of_indecs := Concatenation(list_of_indecs, res[1]);;
        fi;
    od;
    list_of_indecs := Unique(Flat(list_of_indecs));
    return list_of_indecs;
end;


CleanDuplicatesByDimVec := function(list_of_indecs)
    # Assumes that for the algebra, nonisomorphic indecomposable representations
    # have unequal dimension vectors.
    local  cur_dim_vec, cleaned;
    SortBy(list_of_indecs, DimensionVector);
    cur_dim_vec := [];
    Display("cleaned indecs:");
    cleaned := Filtered(list_of_indecs,
                       function(v)
                           local result;
                           result := not(DimensionVector(v) = cur_dim_vec);
                           cur_dim_vec := DimensionVector(v);
                           return result;
                       end
                       );
    return cleaned;
end;

CleanDuplicatesByIsomorphism := function(list_of_indecs)
    # Very inefficient
    local  N, chosen_elems, cleaned, i, j;
    N := Length(list_of_indecs);
    chosen_elems := List([1..N], x->true);
    cleaned := [];
    for i in [1..N] do
        if chosen_elems[i] = true then
            for j in [i+1..N] do
                chosen_elems[j] := not(IsomorphicModules(list_of_indecs[i], list_of_indecs[j]));
            od;
            Append(cleaned, [ list_of_indecs[i] ]);
        fi;
    od;
    return cleaned;
end;

# ****************************************

# ********** Some Tools for creating algebras **********
CreateCommutativeLadder := function(orientation)
    local  A2, AN, A;;
    A2 := PathAlgebra(GF(2), DynkinQuiver("A", 2, ["r"]));
    AN := PathAlgebra(GF(2), DynkinQuiver("A", Length(orientation)+1, orientation));
    A := TensorProductOfAlgebras(A2,AN);
    return A;
end;
