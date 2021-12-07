

__HaveFiniteResolutionInAddMList := function(N, L, n, verbose)
    local A, M, U, differentials, g, f, i, cat, resolution;
    A := RightActingAlgebra(N);
    for M in L do
        if RightActingAlgebra(M) <> A then
            Error("the entered modules are not modules over the same algebra,\n");
        fi;
    od;

    #
    # If n = 0, then this is the same as N being in add M.
    #
    # Computing successive minimal right add<M>-approximation to produce
    # a resolution of  <N>  in  add<M>.
    #
    U := N;
    differentials := [];
    g := IdentityMapping(U);
    # f := MinimalRightAddMApproximation(M,U);
    f := RightMinimalVersion(RightApproximationByAddMCustom(L, U))[1];
    if n = 0 then
        if IsIsomorphism(f) then
            return true;
        else
            return false;
        fi;
    fi;
    for i in [0..n] do
        if verbose = true then
            Print(i); Print("th term:\n");
            Print(DimensionVector(Source(f)));
            Print("\n");
        fi;
        if not IsSurjective(f) then
            return false;
        fi;
        Add(differentials, f*g);
        g := KernelInclusion(f);
        if Dimension(Source(g)) = 0 then
            break;
        fi;
        # f := MinimalRightAddMApproximation(M, Source(g));
        f := RightMinimalVersion(RightApproximationByAddMCustom(L, Source(g)))[1];
    od;
    cat := CatOfRightAlgebraModules(A);
    resolution := FiniteComplex(cat, 1, differentials);
    return resolution;
end;


InstallMethod(HaveFiniteResolutionInAddMList,
              "for a PathAlgebraMatModule, a List of PathAlgebraMatModules and a positive integer",
              [IsPathAlgebraMatModule, IsList, IS_INT],
              function(N, L, n)
                  return __HaveFiniteResolutionInAddMList(N, L, n, "");
              end);

InstallMethod(HaveFiniteResolutionInAddMList,
              "for a PathAlgebraMatModule, a List of PathAlgebraMatModules, a positive integer, and a bool",
              [IsPathAlgebraMatModule, IsList, IS_INT, IsBool],
              function(N, L, n, verbose)
                  return __HaveFiniteResolutionInAddMList(N, L, n, verbose);
              end);


InstallMethod(RightApproximationByAddMCustom,
              "for a list of modules and one module",
              true,
              [ IsList, IsPathAlgebraMatModule ],
              0,
              function( L, C )
                  local   A,  K,  approximation,  i,  homL_iC,  homL_ilessthanL_i,
                          homL_iapproxC,  endL_i,  radendL_i,  RadendL_i,  radmaps,
                          generators,  radgenerators,  generatorshomL_iC,  g,  V,
                          t,  M,  projections,  f;

                  A := RightActingAlgebra( C );
                  if Length( L ) = 0 then
                      return ZeroMapping( ZeroModule( A ), C );
                  fi;
                  if not ForAll( L, l -> RightActingAlgebra( l ) = A ) then
                      Error( "Not all modules in the list of modules entered are modules over the same algebra.\n" );
                  fi;

                  K := LeftActingDomain( A );
                  approximation := [ ];
                  for i in [ 1..Length( L ) ] do
                      homL_iC := HomOverAlgebra( L[ i ], C );
                      if Length( homL_iC ) > 0 then
                          homL_ilessthanL_i := List( [ 1..Length(approximation) ], r -> HomOverAlgebra( L[ i ], Source( approximation[ r ] ) ) );
                          homL_iapproxC := Flat( List( [ 1..Length(approximation) ], r -> homL_ilessthanL_i[ r ] * approximation[ r ] ) );
                          homL_iapproxC := Filtered( homL_iapproxC, h -> not IsZero( h ) );
                          generators := List( homL_iapproxC, h -> Flat( MatricesOfPathAlgebraMatModuleHomomorphism( h ) ) );
                          if Length( generators ) = 0 then
                              generators := [ Flat( MatricesOfPathAlgebraMatModuleHomomorphism( ZeroMapping( L[ i ],C ) ) ) ];
                          fi;

                          endL_i := EndOverAlgebra( L[ i ] );
                          radendL_i := RadicalOfAlgebra( endL_i );
                          RadendL_i := List( BasisVectors( Basis( radendL_i ) ), FromEndMToHomMM );
                          radmaps := Flat( List( homL_iC, h -> RadendL_i * h ) );
                          radgenerators := List( radmaps, h -> Flat( MatricesOfPathAlgebraMatModuleHomomorphism( h ) ) );
                          Append( generators, radgenerators );

                          generatorshomL_iC := List( homL_iC, h -> Flat( MatricesOfPathAlgebraMatModuleHomomorphism( h ) ) );
                          for g in generatorshomL_iC do
                              V := VectorSpace( K, generators );
                              if not g in V then
                                  Add( generators, g );
                                  t := Position( generatorshomL_iC, g );
                                  Add( approximation, homL_iC[ t ] );
                              fi;
                          od;
                      fi;
                  od;

                  M := DirectSumOfQPAModules( List( approximation, Source ) );
                  projections := DirectSumProjections( M );
                  f := Sum( List( [ 1..Length( projections ) ], i -> projections[ i ] * approximation[ i ] ) );

                  return f;
              end
             );
