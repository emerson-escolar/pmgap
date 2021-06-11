#! @Chapter intervals

#! @Section Interval approximation


# --------------------------------------------------
#! @Arguments V
#! @Description Given a commutative grid representation <A>V</A>,
#! precompute the matrices of all the internal maps of <A>V</A>
#! (over paths with length $\geq 1$).
#! The information is stored as a GAP record with lengths 1, 2, ...
#! as the record names, and a list of lists
#! <C>[start_vertex_indices, end_vertex_indices, matrix]</C>
#! as the record entries.
#!
#! @Returns record of matrices
DeclareOperation("MatricesOnPaths", [IsCommGridRepn]);


#! @Arguments V
#! @Description Given a commutative grid representation <A>V</A>,
#! computes its ss-compressed multiplicities as defined
#! in <Cite Key="asashiba2019approximation"/>. The output is
#! encoded as a list of lists
#! [$I$, $c_V(I)$]
#! where $I$ is an interval and $c_V(I)$ is the compressed multiplicity of $V$ at $I$.
#! Intervals $I$ with $c_V(I) = 0$ are excluded from the output
#!
#! @Returns compressed multiplicities
DeclareOperation("CompressedMultiplicity", [IsCommGridRepn]);

#! @Arguments V
#! @Description Given a commutative grid representation <A>V</A>,
#! computes its interval-decomposable approximation as defined
#! in <Cite Key="asashiba2019approximation"/>. The output is
#! encoded as a list of lists
#! [$I$, $\delta_V(I)$]
#! where $I$ is an interval and $\delta_V(I)$ is the multiplicity of $I$
#! in the interval-decomposable approximation of $V$.
#! Intervals $I$ with $\delta_V(I) = 0$ are excluded from the output
#!
#! @Returns multiplicities of interval approximation
DeclareOperation("IntervalApproximation", [IsCommGridRepn]);
