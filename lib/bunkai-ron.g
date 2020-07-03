# Copied from gyoza:
# https://bitbucket.org/remere/gyoza/src/master/
# GPL3



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
