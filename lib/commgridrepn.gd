#! @Chapter Persistence modules (representations)

#! @Section Persistence modules over commutative grids

#! @Arguments filename
#! @Returns commutative grid representation
#! @Description
#! Reads a CommGridRepn from a json file.
DeclareGlobalFunction("JsonFileToCommGridRepn");


#! @Arguments json stream
#! @Returns commutative grid representation
#! @Description
#! Reads a CommGridRepn from a json stream.
DeclareGlobalFunction("JsonToCommGridRepn");

#! @Arguments V
#! @Returns true or false
#! @Description
#! Tells you if V is commutative grid representation or not.
DeclareProperty("IsCommGridRepn", IsPathAlgebraMatModule);
