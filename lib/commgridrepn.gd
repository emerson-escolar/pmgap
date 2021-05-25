#! @Chapter representations

#! @Section Persistence modules over commutative grids

#! @BeginGroup CommGridRepnArrLbl
#! @GroupTitle Representations of commutative grids, specify arrow labels

#! @Description
#! This operation builds the commutative grid representation of
#! the commutative grid path algebra <A>A</A>
#! with given <A>matrices</A> and dimension vector <A>dim_vec</A>.
#! The second variation forgoes inputting of the dimension vector.
#!
#! This is essentially a wrapper around QPA's RightModuleOverPathAlgebra.
#! Thus, the format for <A>matrices</A> is [["a",[matrix_a]],["b",[matrix_b]],...],
#! where "a" and "b" are labels of arrows used when the underlying quiver
#! was created and matrix_? is the action of the
#! algebra element corresponding to the arrow with label "?".
#! See the QPA manual for more details.
#! This requires knowledge of the arrow labels, which may not be very convenient.

#! @Arguments A, dim_vec, matrices
#! @Returns CommGridRepn
DeclareOperation("CommGridRepnArrLbl", [IsCommGridPathAlgebra, IsList, IsList]);

#! @Arguments A, matrices
#! @Returns CommGridRepn
DeclareOperation("CommGridRepnArrLbl", [IsCommGridPathAlgebra, IsCollection]);
#! @EndGroup


#! @BeginGroup CommGridRepn
#! @GroupTitle Representations of commutative grids

#! @Description
#! This operation builds the commutative grid representation of
#! the commutative grid path algebra <A>A</A>
#! with given <A>matrices</A> and dimension vector <A>dim_vec</A>.
#! The second variation forgoes inputting of the dimension vector.
#!
#! The format for <A>matrices</A> is [["sa", "ta", [matrix_a]], ...
#! where "sa" ("ta", respectively) is the label of the
#! source vertex (target vertex, respectively) of an arrow a,
#! and matrix_a is the action of its corresponding algebra element.
#! Since we are working with commutative grids, specifying the source and target
#! is enough to specify at most one arrow.

#! @Arguments A, dim_vec, matrices
#! @Returns CommGridRepn
DeclareOperation("CommGridRepn", [IsCommGridPathAlgebra, IsList, IsList]);

#! @Arguments A, matrices
#! @Returns CommGridRepn
DeclareOperation("CommGridRepn", [IsCommGridPathAlgebra, IsCollection]);
#! @EndGroup


#! @Arguments V
#! @Returns true or false
#! @Description
#! Tells you if <A>V</A> is commutative grid representation.
DeclareProperty("IsCommGridRepn", IsPathAlgebraMatModule);


#! @Arguments V
#! @Returns true or false
#! @Description
#! Tells you if <A>V</A> is equioriented $A_n$ representation.
DeclareProperty("IsEquiorientedAnRepn", IsPathAlgebraMatModule);


#! @Section Reading from files

#! @BeginGroup JsonToCommGridRepn
#! @GroupTitle Representations of commutative grids from json

#! @Description
#! Reads a <Ref Func="CommGridRepn"/> from json format.
#! The first and second variations expect
#! an <C>InputTextStream</C> <A>json_stream</A>,
#! while the third and fourth variations expect
#! a filename <A>json_filename</A>.
#! Furthermore, the second and fourth variations
#! reuses an already built commutative grid path algebra <A>A</A>,
#! which should match the size and the underlying field
#! specified in the json file.
#!
#! Below is the specification of the json format.
#!
#! <List>
#! <Item>
#! One JSON object
#! (an unordered set of name/value pairs,
#! given by {name1:value1, name2:value2,...})
#! is expected.
#! </Item>
#!
#! <Item>
#! An optional name "field", if present,
#! specifies the underlying field.
#! It can be associated to the value "rationals",
#! or a prime-power integer n. In the former case,
#! the underlying field shall be Rationals;
#! in the latter, GF(n).
#! </Item>
#!
#! <Item>
#! The following names are expected
#! to be present in this object:
#! "rows", "cols",
#! "dimensions", and "matrices".
#!   <List>
#!   <Item>
#!   The values associated to "rows" and "cols"
#!   specify the size of the underlying
#!   commutative grid path algebra.
#!   </Item>
#!   <Item>
#!   The value associated to "dimensions"
#!   is a JSON object associating vertices (names)
#!   to dimensions (values).
#!   Vertices are to be given in the format "i_j",
#!   for the vertex at the ith row and jth column.
#!   </Item>
#!   <Item>
#!   The value associated to "matrices"
#!   is a JSON object associating
#!   arrows (names) to matrices (values).
#!   arrows are to be given in the format "s_t",
#!   where s corresponding to the source vertex
#!   and t is the target vertex. Vertices are given in
#!   the format as in "dimensions". For example,
#!   "2_1_2_2" specifies the arrow from 2_1 to 2_2.
#!   The values are matrices, given by JSON arrays of
#!   JSON arrays of values.
#!   </Item>
#!   </List>
#! </Item>
#!
#! <Item>
#! If the optional name "is_left_matrices" is present
#! and takes on the value false, then the matrices
#! shall be interpreted as right-acting matrices.
#! Otherwise, if it is true, or if the name
#! "is_left_matrices" is not present, then
#! the matrices shall be interpreted as left-acting.
#! </Item>
#! </List>
#!
#! @Returns commutative grid representation in the json data

#! @Arguments json_stream
DeclareOperation("JsonToCommGridRepn", [IsInputTextStream]);

#! @Arguments json_stream, A
DeclareOperation("JsonToCommGridRepn", [IsInputTextStream, IsCommGridPathAlgebra]);

#! @Arguments json_filename
DeclareOperation("JsonFileToCommGridRepn", [IsString]);

#! @Arguments json_filename, A
DeclareOperation("JsonFileToCommGridRepn", [IsString, IsCommGridPathAlgebra]);
#! @EndGroup


#! @Description
#! Reads commutative grid representations over the same commutative grid path algebra
#! from a list of json files. **Note that the underlying commutative grid path algebra
#! should be the same for all the files**.
#! See documentation for <Ref Oper="JsonToCommGridRepn"/> for information about the file format.
#! @Arguments list_of_json_filenames
#! @Returns list commutative grid representations in the json files
DeclareOperation("JsonFilesToCommGridRepn", [IsList]);

#! @BeginGroup CommGridRepnToJson
#! @GroupTitle Representations of commutative grids to json format

#! @Arguments comm_grid_repn, json_stream
DeclareOperation("CommGridRepnToJson", [IsCommGridRepn, IsOutputTextStream]);

#! @Arguments comm_grid_repn, json_filename
DeclareOperation("CommGridRepnToJsonFile", [IsCommGridRepn, IsString]);
#! @EndGroup
