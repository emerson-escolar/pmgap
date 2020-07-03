#! @Chapter Persistence modules (representations)

#! @Section Persistence modules over commutative grids

#! @BeginGroup CommGridRepnArrLbl
#! @GroupTitle Representations of commutative grids, specify arrow labels

#! @Description
#! This operation builds the commutative grid representation
#! with given matrices and dimension vector.
#! The second variation forgoes inputting of the dimension vector.
#!
#! This is essentially a wrapper around QPA's RightModuleOverPathAlgebra.
#! Thus, the format for matrices [["a",[matrix_a]],["b",[matrix_b]],...],
#! where "a" and "b" are labels of arrows used when the underlying quiver
#! was created and matrix_? is the action of the
#! algebra element corresponding to the arrow with label "?".
#! See the QPA manual for more details.
#! This requires knowledge of the arrow labels, which may not be very convenient.

#! @Arguments comm_grid_path_algebra, dim_vec, matrices
#! @Returns CommGridRepn
DeclareOperation("CommGridRepnArrLbl", [IsCommGridPathAlgebra, IsList, IsList]);

#! @Arguments comm_grid_path_algebra, matrices
#! @Returns CommGridRepn
DeclareOperation("CommGridRepnArrLbl", [IsCommGridPathAlgebra, IsCollection]);
#! @EndGroup


#! @BeginGroup CommGridRepn
#! @GroupTitle Representations of commutative grids

#! @Description
#! This operation builds the commutative grid representation
#! with given matrices and dimension vector.
#! The second variation forgoes inputting of the dimension vector.
#!
#! The format for matrices is [["sa", "ta", [matrix_a]], ...
#! where "sa" ("ta", respectively) is the label of the
#! source vertex (target vertex, respectively) of an arrow a,
#! and matrix_a is the action of its corresponding algebra element.
#! Since we are working with commutative grids, specifying the source and target
#! is enough to specify at most one arrow.

#! @Arguments comm_grid_path_algebra, dim_vec, matrices
#! @Returns CommGridRepn
DeclareOperation("CommGridRepn", [IsCommGridPathAlgebra, IsList, IsList]);

#! @Arguments comm_grid_path_algebra, matrices
#! @Returns CommGridRepn
DeclareOperation("CommGridRepn", [IsCommGridPathAlgebra, IsCollection]);
#! @EndGroup


#! @Arguments V
#! @Returns true or false
#! @Description
#! Tells you if V is commutative grid representation.
#! Works only for the representations constructed using the
#! functions provided by this package.
DeclareProperty("IsCommGridRepn", IsPathAlgebraMatModule);


#! @Arguments V
#! @Returns true or false
#! @Description
#! Tells you if V is equioriented An representation.
#! Works only for the representations constructed using the
#! functions provided by this package.
DeclareProperty("IsEquiorientedAnRepn", IsPathAlgebraMatModule);

#! @Section Reading from files

#! @Arguments filename
#! @Returns CommGridRepn
#! @Description
#! Reads a CommGridRepn from a json file.
DeclareGlobalFunction("JsonFileToCommGridRepn");


#! @Arguments json stream
#! @Returns CommGridRepn
#! @Description
#! Reads a CommGridRepn from a json stream.
DeclareGlobalFunction("JsonToCommGridRepn");
