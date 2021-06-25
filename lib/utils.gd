#! @Chapter utils

#! @Section Vector spaces and linear maps

#! @Description pullback
#! @Arguments Af, Ag
#! @Returns pullback
DeclareOperation("PullbackMatrices", [IsMatrix, IsMatrix]);


DeclareOperation("StackMatricesHorizontalConcat", [IsMatrix, IsMatrix]);
DeclareOperation("StackMatricesVerticalConcat", [IsMatrix, IsMatrix]);

DeclareOperation("StackMatricesHorizontalCopy", [IsMatrix, IsMatrix]);
DeclareOperation("StackMatricesVerticalCopy", [IsMatrix, IsMatrix]);
