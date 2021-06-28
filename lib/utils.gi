


__StackMatricesVertical := function(A, B)
    local shapeA, shapeB;
    shapeA := DimensionsMat(A);
    shapeB := DimensionsMat(B);
    if shapeA = fail or shapeB = fail or shapeA[2] <> shapeB[2] then
        return fail;
    fi;
    return Concatenation(A,B);
end;


InstallMethod(StackMatricesVerticalConcat,
              "for matrix and a matrix",
              ReturnTrue,
              [IsMatrix, IsMatrix],
              __StackMatricesVertical);

InstallMethod(StackMatricesVerticalCopy,
              "for matrix and a matrix",
              ReturnTrue,
              [IsMatrix, IsMatrix],
              function(A,B)
                  return StructuralCopy(StackMatricesVerticalConcat(A,B));
              end);


__StackMatricesHorizontal := function(A, B)
    local AB, i,
          shapeA, shapeB;
    shapeA := DimensionsMat(A);
    shapeB := DimensionsMat(B);
    if shapeA = fail or shapeB = fail or shapeA[1] <> shapeB[1] then
        return fail;
    fi;
    AB := [];
    for i in [1..shapeA[1]] do
        Add(AB, Concatenation(A[i],B[i]));
    od;
    return AB;
end;

InstallMethod(StackMatricesHorizontalConcat,
              "for matrix and a matrix",
              ReturnTrue,
              [IsMatrix, IsMatrix],
              __StackMatricesHorizontal);

InstallMethod(StackMatricesHorizontalCopy,
              "for matrix and a matrix",
              ReturnTrue,
              [IsMatrix, IsMatrix],
              function(A,B)
                  return StructuralCopy(StackMatricesHorizontalConcat(A,B));
              end);






__PullbackMatrices := function(Af, Ag)
    local n1, n2, K, k;

    if DimensionsMat(Af)[2] <> DimensionsMat(Ag)[2] then
        return fail;
    fi;

    n1 := DimensionsMat(Af)[1];
    n2 := DimensionsMat(Ag)[1];

    K := NullspaceMat(StackMatricesVerticalConcat(Af, -Ag));

    if Length(K) = 0 then
        return fail;
    fi;

    k := DimensionsMat(K)[1];
    return [K{[1..k]}{[1..n1]}, K{[1..k]}{[n1+1..n1+n2]}];
end;


InstallMethod(PullbackMatrices,
              "for matrix and a matrix",
              ReturnTrue,
              [IsMatrix, IsMatrix],
              __PullbackMatrices);


InstallGlobalFunction(RandomMatFixedRank, function (arg)
    local rs, m, n, k, R, mat, i;

    if Length(arg) >= 1 and IsRandomSource(arg[1]) then
        rs := Remove(arg, 1);
    else
        rs := GlobalMersenneTwister;
    fi;

    # check the arguments and get the list of elements
    if Length(arg) = 3  then
        m := arg[1];
        n := arg[2];
        k := arg[3];
        R := Integers;
    elif Length(arg) = 4  then
        m := arg[1];
        n := arg[2];
        k := arg[3];
        R := arg[4];
    else
        Error("usage: RandomMatFixedRank( [rs ,] <m>, <n>, <k> [, <R>] )");
    fi;
    if k < 0 or k > Minimum(m,n) then
        Error("Impossible rank k requested in RandomMat( [rs ,] <m>, <n>, <k> [, <R>] )");
    fi;

    mat := NullMat(m,n, R);
    for i in [1..k] do
        mat[i][i] := Identity(R);
    od;

    mat := RandomInvertibleMat(rs, m, R) * mat * RandomInvertibleMat(rs, n, R);
    return mat;
                     end);


InstallGlobalFunction(RandomMatRandomRank, function (arg)
    local rs, m, n, rank_rs, R, k, mat;

    if Length(arg) >= 1 and IsRandomSource(arg[1]) then
        rs := Remove(arg, 1);
    else
        rs := GlobalMersenneTwister;
    fi;

    # check the arguments and get the list of elements
    if Length(arg) = 2  then
        m := arg[1];
        n := arg[2];
        rank_rs := GlobalMersenneTwister;
        R := Integers;
    elif Length(arg) = 3  then
        m := arg[1];
        n := arg[2];
        if IsRandomSource(arg[3]) then
            rank_rs := arg[3];
            R := Integers;
        else
            rank_rs := GlobalMersenneTwister;
            R := arg[3];
        fi;
    elif Length(arg) = 4  then
        m := arg[1];
        n := arg[2];
        rank_rs := arg[3];
        R := arg[4];
    else
        Error("usage: RandomMatRandomRank( [rs ,] <m>, <n>, [, rank_rs, <R>] )");
    fi;

    k := RandomList(rank_rs, [0..Minimum(m,n)]);
    mat := RandomMatFixedRank(rs, m, n, k, R);
    return mat;
                     end);
