


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
