#! @Chapter Persistence modules (representations)

#! @Section Useful operations

#! @Description
#! Computes the multiplicity of indecomposable_module as direct summand of path_algebra_mat_module. Currently uses the algorithm of computing dimhom to the Auslander-Reiten mesh of indecomposable_module.
#! @Returns multiplicity

#! @Arguments path_algebra_mat_module, indecomposable_module
DeclareOperation("MultiplicityAtIndec",
                 [IsPathAlgebraMatModule, IsIndecomposableModule]);

#! @Description
#! Computes the multiplicities of the indecomposable modules in list_of_indec_modules as direct summands of path_algebra_mat_module. Currently uses the algorithm of computing dimhom to the Auslander-Reiten mesh of indecomposable_module.

#! @Arguments path_algebra_mat_module, list_of_indec_modules
DeclareOperation("ComputeMultiplicities",
                 [IsPathAlgebraMatModule, IsListOrCollection]);
