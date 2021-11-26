
InstallMethod(HaveFiniteResolutionInAddMList,
              "for a PathAlgebraMatModule, a List of PathAlgebraMatModules and a positive integer",
              [ IsPathAlgebraMatModule, IsList, IS_INT ],

              function( N, L, n )
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
                  f := RightMinimalVersion(RightApproximationByAddM(L, U))[1];
                  if n = 0 then
                      if IsIsomorphism( f ) then
                          return true;
                      else
                          return false;
                      fi;
                  fi;
                  for i in [0..n] do
                      Print(i); Print("th term:\n");
                      Print(DimensionVector(Source(f)));
                      Print("\n");
                      if not IsSurjective(f) then
                          return false;
                      fi;
                      Add(differentials, f*g);
                      g := KernelInclusion(f);
                      if Dimension(Source(g)) = 0 then
                          break;
                      fi;
                      # f := MinimalRightAddMApproximation(M, Source(g));
                      f := RightMinimalVersion(RightApproximationByAddM(L, Source(g)))[1];
                  od;
                  cat := CatOfRightAlgebraModules(A);
                  resolution := FiniteComplex(cat, 1, differentials);
                  return resolution;
              end
             );
