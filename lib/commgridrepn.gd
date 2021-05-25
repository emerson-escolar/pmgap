#! @Chapter representations

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
#! Works only for the representations constructed
#! using the functions provided by this package.
DeclareProperty("IsCommGridRepn", IsPathAlgebraMatModule);


#! @Arguments V
#! @Returns true or false
#! @Description
#! Tells you if V is equioriented An representation.
#! Works only for the representations constructed
#! using the functions provided by this package.
DeclareProperty("IsEquiorientedAnRepn", IsPathAlgebraMatModule);


#! @Section Reading from files

#! @BeginGroup JsonToCommGridRepn
#! @GroupTitle Representations of commutative grids from json

#! @Description
#! Reads a CommGridRepn from json format.
#! The first and second variations expect
#! an InputTextStream,
#! while the third and fourth variations expect
#! a filename.
#! Furthermore, the second and fourth variations
#! reuses an already built CommGridPathAlgebra,
#! which should match the size and underlying field
#! specified in the json format.
#!
#! One JSON object
#! (an unordered set of name/value pairs,
#! given by {name1:value1, name2:value2,...})
#! is expected.
#!
#! First, an optional name "field", if present,
#! specifies the underlying field.
#! It can be associated to the value "rationals",
#! or a prime-power integer n. In the former case,
#! the underlying field shall be Rationals;
#! in the latter, GF(n).
#!
#! Next, the following names are expected
#! to be present in this object:
#! "rows", "cols",
#! "dimensions", and "matrices".

#! The values associated to "rows" and "cols"
#! specify the size of the underlying
#! commutative grid path algebra.

#! The value associated to "dimensions"
#! is a JSON object associating vertices (names)
#! to dimensions (values).
#! Vertices are to be given in the format "i_j",
#! for the vertex at the ith row and jth column.
#!
#! The value associated to "matrices"
#! is a JSON object associating
#! arrows (names) to matrices (values).
#! arrows are to be given in the format "s_t",
#! where s corresponding to the source vertex
#! and t is the target vertex. Vertices are given in
#! the format as in "dimensions". For example,
#! "2_1_2_2" specifies the arrow from 2_1 to 2_2.
#! The values are matrices, given by JSON arrays of
#! JSON arrays of values.
#!
#! If the optional name "is_left_matrices" is present
#! and takes on the value false, then the matrices
#! shall be interpreted as right-acting matrices.
#! Otherwise, if it is true, or if the name
#! "is_left_matrices" is not present, then
#! the matrices shall be interpreted as left-acting.

#! @Returns CommGridRepn

#! @Arguments json_stream
DeclareOperation("JsonToCommGridRepn", [IsInputTextStream]);

#! @Arguments json_stream, comm_grid_path_algebra
DeclareOperation("JsonToCommGridRepn", [IsInputTextStream, IsCommGridPathAlgebra]);

#! @Arguments json_filename
DeclareOperation("JsonFileToCommGridRepn", [IsString]);

#! @Arguments json_filename, comm_grid_path_algebra
DeclareOperation("JsonFileToCommGridRepn", [IsString, IsCommGridPathAlgebra]);
#! @EndGroup


#! @Description
#! Reads CommGridRepns over the same CommGridPathAlgebra from a list of json files.
#! See documentation for JsonFileToCommGridRepn for information about the file format.
#! @Arguments list_of_json_filenames
#! @Returns list of CommGridRepns
DeclareOperation("JsonFilesToCommGridRepn", [IsList]);



#! @Arguments comm_grid_repn, json_stream
DeclareOperation("CommGridRepnToJson", [IsCommGridRepn, IsOutputTextStream]);

#! @Arguments comm_grid_repn, json_filename
DeclareOperation("CommGridRepnToJsonFile", [IsCommGridRepn, IsString]);
