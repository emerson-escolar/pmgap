#! @Chapter Persistence modules (representations)

#! @Section Useful operations

#! @Description
#! Computes the multiplicity of indecomposable_module as direct summand of path_algebra_mat_module. Currently uses the algorithm of computing dimhom to the Auslander-Reiten mesh of indecomposable_module.
#! @Returns multiplicity

#! @Arguments path_algebra_mat_module, indecomposable_module
DeclareOperation("MultiplicityAtIndec",
                 [IsPathAlgebraMatModule, IsIndecomposableModule]);
