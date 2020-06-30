#! @Chapter Persistence modules (representations)




#! @Section Persistence modules over commutative grids

#! @Arguments filename
#! @Returns commutative grid representation
#! @Description
#! Reads a CommGridRepn from a json file
DeclareGlobalFunction("JsonFileToCommGridRepn");


#! @Arguments json stream
#! @Returns commutative grid representation
#! @Description
#! Reads a CommGridRepn from a json stream
DeclareGlobalFunction("JsonToCommGridRepn");

#!
DeclareProperty("IsCommGridRepn", IsPathAlgebraMatModule);
